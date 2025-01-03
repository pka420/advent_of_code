#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input.txt';
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
            push @nums2, sprintf("%d", $k);
        }
        $k++;
    } else {
        for my $j ( 1 .. $nums[$i]) {
            push @nums2, '.';
        }
    }
}

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
    my $i = scalar(@nums2) - 1;
    my $num = $nums2[$i];
    my $max_left = scalar(@nums2) - 1 ;
    while ($num > 0) {
        my $left = 0;
        my $num_count = 0;
        my ($right) = grep { $nums2[$_] eq $num } 0..$#nums2;
        my $temp_right = $right;
        while($temp_right <= $#nums2 && $nums2[$temp_right] eq $num) {
            $temp_right++;
            $num_count++;
        }
        while($left < $max_left){
            my $dot_count = 0;
            while($nums2[$left] ne '.') {
                $left++;
            }
            my $temp_left = $left;
            if ( $left >= $right) {
                $max_left = $left;
                last;
            }
            while($nums2[$temp_left] eq '.') {
                $dot_count++;
                $temp_left++;
            }

            if ( $dot_count >= $num_count) {
                while($num_count>0) {
                    $nums2[$left] = $num;
                    $nums2[$right] = '.';
                    $num_count--;
                    $right++;
                    $left++;
                }
                last;
            }
            $left+=$dot_count;
        }
        $num--;
    }

    print join("", @nums2), "\n";
    print("\n");

    for my $i (0 .. $#nums2) {
        if ( $nums2[$i] eq '.') {
            next;
        }
        $checksum = $checksum + $nums2[$i]*$i
    }

	print("Part 2: ", $checksum, "\n");
}

part2();

