#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @nums;

while (my $line = <$fh>) {
    chomp $line;
    @nums = split //, $line;
}

close $fh;

print("\n");
my @nums2;
my $k = 0;
for my $i (0 .. $#nums) {
    if ($i%2 == 0) {
        for my $j ( 1 .. $nums[$i]) {
            push @nums2, $k;
        }
        $k++;
    } else {
        for my $j ( 1 .. $nums[$i]) {
            push @nums2, '.';
        }
    }
}
print join("", @nums2), "\n";
print("\n");

sub part1 {
	my $checksum=0;
    my $left = 0;
    my $right = scalar(@nums2) - 1;

    while ($left < $right) {
        while ($left < $right && $nums2[$left] ne '.') {
            $left++;
        }
        while ($left < $right && $nums2[$right] eq '.') {
            $right--;
        }
        if ($left < $right) {
            ($nums2[$left], $nums2[$right]) = ($nums2[$right], $nums2[$left]);
            $left++;
            $right--;
        }
    }

    print join("", @nums2), "\n";
    print("\n");

    for my $i (0 .. $#nums2) {
        if ( $nums2[$i] eq '.') {
            last;
        }
        $checksum = $checksum + $nums2[$i]*$i
    }

	print("Part 1: ", $checksum, "\n");
}

sub part2 {
	my $checksum=0;

    my $left = 0;
    my $right = scalar(@nums2) - 1;

    while ($left < $right) {
    }

    print join("", @nums2), "\n";
    print("\n");

    for my $i (0 .. $#nums2) {
        if ( $nums2[$i] eq '.') {
            last;
        }
        $checksum = $checksum + $nums2[$i]*$i
    }

	print("Part 2: ", $checksum, "\n");
}

part2();

