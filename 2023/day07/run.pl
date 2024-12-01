#!/bin/perl
use Text::CSV_XS;


my $csv = Text::CSV_XS->new({ sep_char => ',' });
my $file = 'test.csv';
open my $fh, '<', $file or die "Could not open '$file': $!";


$sum=0;
$n=6;
$idx=1;
while (my $row = $csv->getline($fh)) {
    my $hand = $row->[0];
    my $bid = $row->[1];

    ## five of a kind.
    if ($hand =~ /(.)\1{4}/ ) {
        print "five of a hand $hand \n";
    }

    ## four of a kind.
    if ($hand =~ /(.)\1{3}/ ) {
        print "four of a kind $hand \n";
    }

    ## full house
    if ($hand =~ /(.)\1{2}(.)\2/ ) {
        print "full house $hand \n";
    }

    ## three of a kind.
    if ($hand =~ /(.)\1{2}/ ) {
        print "three of a kind $hand \n";
    }

    ## two pair.
    if ($hand =~ /(.)\1(.)\2/ ) {
        print "two pair $hand \n";
    }

    ## one pair.
    if ($hand =~ /(.)\1/ ) {
        print "one pair $hand \n";
    }

    ## high card
    if ($hand =~ /./ ) {
        print "high card $hand \n";
    }

    # print "hand $hand bid $bid \n";
}
