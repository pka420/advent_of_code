#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @map;

while (my $line = <$fh>) {
    chomp $line;
		my @list = split //, $line;
		push @map, \@list;
}

close $fh;


for my $i (0 .. $#map) {
	for my $j (0 .. $#{$map[$i]}) {
		print($map[$i][$j]);
	}
	print("\n");
}

