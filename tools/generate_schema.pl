#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(:all);

use DBI qw(:sql_types);
use DBD::Pg qw(:pg_types);


my %items;

my $source_dir = '~/pggit/pgbouncer';

# First, the SHOW commands. They are more transparent.
# Go straight to the source's mouth.
open my $fh, '-|', qq!grep -ERo '{([^[:space:]]+), .*admin_show.*}' $source_dir/* | cut -d '"' -f 2!
    or die "Couldn't find the admin_show commands in the source: $!";

while (my $line = <$fh>) {
    chomp $line;
    $items{$line} = 1;
}

close $fh;

=begin GHOST_CODE
my $dbh=DBI->connect('dbi:Pg:dbname=pgbouncer;host=/tmp;port=6432','pgbouncer','')
    or die "Couldn't connect to pgbouncer: $!";

my $dbh_pg=DBI->connect('dbi:Pg:dbname=postgres','postgres','')
    or die "Couldn't connect to PostgreSQL: $!";

sub fix_names {
    my ($type, $name) = @_;
    if ($type eq "int4") {
        return "integer";
    }
    elsif ($type eq "int8") {
        return "bigint";
    }
    elsif ($name =~ m/_time$/) {
        return "timestamp";
    }
    elsif ($name eq 'changeable') {
        return "boolean";
    }
    else {
        return $type;
    }
}

foreach my $item(sort keys %items) {
    my $sth = $dbh->prepare("SHOW $item");
    $sth->execute;
    my $sth_pg = $dbh_pg->prepare("VALUES(pg_catalog.quote_ident(?))");
    my $name = $sth->{NAME_lc_hash};
    my $type = $sth->{pg_type};
    my @col_names = sort { $name->{$a} <=> $name->{$b} } keys %{$name};
    my @cols;

    foreach my $col (@col_names) {
        $sth_pg->execute($col);
        my @cn = $sth_pg->fetchrow_array;
        $sth->finish;
        my $t = fix_names($type->[$name->{$col}], $cn[0]);
        push @cols, join(" ", $cn[0], $t);
    }

    if ( $#cols > 0 ) {
        say <<~EOT;
        /* SHOW @{[uc($item)]} */
        CREATE VIEW pgbouncer.$item AS
            SELECT * FROM dblink('pgbouncer', 'show $item') AS _(
                @{[ join(",\n        ", @cols) ]}
            );
        EOT
    }
    else {
        say <<~EOT;
        /* SHOW @{[uc($item)]} */
        /* XXX Not implemented as this comes in as a NOTICE, not as a rowset. */
        EOT
    }
}

$dbh->disconnect;
$dbh_pg->disconnect;

=end GHOST_CODE
=cut

# Now, the rest:
open $fh, '-|', qq!grep -ERo '{([^[:space:]]+), .*admin_cmd.*}' $source_dir/* | cut -d '"' -f 2 | grep -v show!
    or die "Couldn't find the rest of the commands in the source: $!";

%items=();

while (my $line = <$fh>) {
    chomp $line;
    next if $line eq 'select';
    $items{$line}=1;
}

my @no_params = qw(suspend shutdown reload);
my @non_optional_params = qw(disable enable kill);

foreach my $item (sort keys %items) {
    if (grep(/^$item$/, @no_params)) {
        say <<~EOT
        /* @{[uc($item)]} */
        CREATE FUNCTION pgbouncer.$item()
        RETURNS VOID
        LANGUAGE sql
        AS \$\$
            SELECT dblink_exec('pgbouncer', '$item');
        \$\$;
        EOT
    }
    elsif (grep(/^$item$/, @non_optional_params)) {
        say <<~EOT
        /* @{[uc($item)]} db */
        CREATE FUNCTION pgbouncer.$item(db TEXT)
        RETURNS VOID
        LANGUAGE sql
        AS \$\$
            SELECT dblink_exec('pgbouncer', format('%s %s', '$item', db));
        \$\$;
        EOT
    }
    else {
        say <<~EOT
        /* @{[uc($item)]} [db] */
        CREATE FUNCTION pgbouncer.$item(db TEXT DEFAULT NULL)
        RETURNS VOID
        LANGUAGE sql
        AS \$\$
        SELECT
            dblink_exec('pgbouncer', format('%s%s', '$item', COALESCE(' ' || db, '')));
        \$\$;
        EOT
    }
}
say <<~'EOT'
/* SET key = value */
CREATE FUNCTION pgbouncer."set"(key TEXT, value TEXT)
RETURNS VOID
LANGUAGE SQL
AS $$
SELECT
    dblink_exec('pgbouncer', format('SET %s=%L', key, value));
$$;
EOT
