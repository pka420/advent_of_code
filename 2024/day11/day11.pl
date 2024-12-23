#!/opt/local/bin/perl
use strict;
use warnings;
use Memoize;

#my @stones = (125, 17);
my @stones = (112,1110,163902,0,7656027,83039,9,74);
memoize('num_stones');

sub num_stones {
    my ($s, $itr) = @_;
    if ($itr == 0) {
        return 1;
    } elsif ( $s == 0 ) {
        return num_stones(1, $itr-1);
    } elsif ( length($s)%2 == 0) {
        my $len = length($s);
        return num_stones(int(substr($s, 0, $len/2)), $itr-1) + num_stones(int(substr($s, $len/2, $len)), $itr-1);
    } else {
        return num_stones($s*2024, $itr-1);
    }
}

my $sum = 0;
for my $j ( 0 .. $#stones) {
    $sum += num_stones($stones[$j], 75);
}
print("final num of stones: ", $sum, "\n");


