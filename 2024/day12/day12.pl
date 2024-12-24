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

my @directions = ( [1, 0], [-1, 0], [0, 1], [0, -1] );

my @alphabets = ('A', 'B', 'C', 'D', 'E');

sub find_regions {
    my @map = @_; # Assuming @map is passed as an argument to the function
    my %area;
    my %visited;

    for my $k (0 .. $#alphabets) {
        for my $i (0 .. $#map) {
            for my $j (0 .. $#{$map[$i]}) {
                if (!$visited{"$i,$j"} && $map[$i][$j] eq $alphabets[$k]) {
                    # Start BFS to find the region for the current alphabet
                    $area{$alphabets[$k]}++;
                    my @queue = ([$i, $j]);
                    $visited{"$i,$j"} = 1;

                    while (@queue) {
                        my ($x, $y) = @{shift @queue};

                        for my $dir (@directions) {
                            my ($dx, $dy) = @$dir;
                            my ($new_x, $new_y) = ($x + $dx, $y + $dy);

                            # Check boundaries and conditions
                            if ($new_x >= 0 && $new_x <= $#map &&
                                $new_y >= 0 && $new_y <= $#{$map[0]} &&
                                !$visited{"$new_x,$new_y"} &&
                                $map[$new_x][$new_y] eq $alphabets[$k]
                            ) {
                                $visited{"$new_x,$new_y"} = 1;
                                $area{$alphabets[$k]}++;
                                push @queue, [$new_x, $new_y];
                            }
                        }
                    }
                }
            }
        }
    }

    # Print results
    foreach my $key (keys %area) {
        print "$key: $area{$key}\n";
    }
}

find_regions();
