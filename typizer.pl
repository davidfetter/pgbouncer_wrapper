#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(:all);

use DBI qw(:sql_types);
use DBD::Pg qw(:pg_types);

my @items;

open my $fh, "-|", "psql -U pgbouncer -p 6432 -AqtXc 'SHOW help' 2>&1"
    or die "Couldn't open psql to pgbouncer: $!";
foreach my $line(<$fh>) {
    next unless $line =~ /SHOW (\S+)/;
    push @items, map{lc} split(/\|/, $1);
}
close $fh;

my $dbh=DBI->connect('dbi:Pg:dbname=pgbouncer;port=6432','pgbouncer','');
foreach my $item(sort {$a cmp $b} @items) {
    my $sth=$dbh->prepare("SHOW $item");
    $sth->execute;
    my $name=$sth->{NAME_lc_hash};
    my $type=$sth->{pg_type};
    my @cols = map { "$_ $type->[$name->{$_}]" } sort { $name->{$a} <=> $name->{$b} } keys %{$name};
    next unless $#cols > 0;
    say <<EOT;
CREATE VIEW pgbouncer.$item AS
SELECT * FROM dblink('pgbouncer', 'show $item') AS _(
    @{[ join(",\n    ", @cols)]}
);
EOT
}
