#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(:all);

use DBI qw(:sql_types);
use DBD::Pg qw(:pg_types);
use Path::Tiny;

die "Unfortunately, DBD::Pg $DBD::Pg::VERSION breaks this software"
    if $DBD::Pg::VERSION eq '3.8.0';

my $source_dir = $ENV{PGB_SOURCE} || '~/pggit/pgbouncer';

# Go straight to the source's mouth.
# First, the SHOW commands.
my @items;
my $iter = path($source_dir)->iterator({recurse => 1});
while (my $path = $iter->()) {
    next unless $path->is_file;
    my @lines = $path->lines;
    foreach my $line (@lines) {
        next unless $line =~ /"([^"]*)", admin_show/;
        push @items, $1;
    }
}
@items = sort @items;

my $dbi_dsn_pgb = $ENV{DBI_DSN_PGB} || 'dbi:Pg:dbname=pgbouncer;host=/tmp;port=6432';
my $pgb_user = $ENV{PGB_USER} || 'pgbouncer';
my $pgb_password = $ENV{PGB_PASSWORD} || '';
my $dbh=DBI->connect($dbi_dsn_pgb, $pgb_user, $pgb_password)
    or die "Couldn't connect to pgbouncer: $!";

my $dbi_dsn_pg = $ENV{DBI_DSN_PG} || 'dbi:Pg:dbname=postgres';
my $pg_user = $ENV{PG_USER} || 'postgres';
my $pg_password = $ENV{PG_PASSWORD} || '';
my $dbh_pg=DBI->connect($dbi_dsn_pg, $pg_user, $pg_password)
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

foreach my $item(@items) {
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

    if ( $#cols >= 0 ) {
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

# Now, the rest:
@items = ();
$iter = path($source_dir)->iterator({recurse => 1});
while (my $path = $iter->()) {
    next unless $path->is_file;
    my @lines = $path->lines;
    foreach my $line (@lines) {
        next unless $line =~ /.*"([^"]*)", admin_cmd/;
        next if $1 =~ /(show|select)/;
        push @items, $1;
    }
}
@items = sort @items;

my @no_params = qw(suspend shutdown reload);
my @non_optional_params = qw(disable enable kill);

foreach my $item (@items) {
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
            SELECT dblink_exec('pgbouncer', pg_catalog.format('%s%s', '$item', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
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
            dblink_exec('pgbouncer', pg_catalog.format('%s%s', '$item', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
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
    dblink_exec('pgbouncer', pg_catalog.format('SET %s=%L', key, value));
$$;
EOT
