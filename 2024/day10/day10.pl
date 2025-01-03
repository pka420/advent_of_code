#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @map;

while (my $line = <$fh>) {
    chomp $line;
		my @list = split //, $line;
		push @map, \@list;
}

close $fh;

my @directions = ( [1, 0], [-1, 0], [0, 1], [0, -1] );

sub get_paths {
    my ($start_x, $start_y) = @_;
    my @queue = ( [$start_x, $start_y, 0, []] );
    my %visited;
    $visited{"$start_x,$start_y"} = 1;

    my $num_paths = 0;

    while (@queue) {
        my ($x, $y, $steps, $path) = @{shift @queue};
        my @current_path = (@$path, [$x, $y]);
        $num_paths++ if $map[$x][$y] == 9;
        for my $dir (@directions) {
            my ($dx, $dy) = @$dir;
            my ($new_x, $new_y) = ($x + $dx, $y + $dy);
            if ($new_x >= 0 && $new_x <= $#map &&
                $new_y >= 0 && $new_y <= $#{$map[0]} &&
                !$visited{"$new_x,$new_y"} &&
                ($map[$new_x][$new_y] - $map[$x][$y] == 1)
            ) {
                push @queue, [$new_x, $new_y, $steps + 1, \@current_path];
                $visited{"$new_x,$new_y"} = 1;
            }
        }
    }
    return $num_paths;
}

sub part1 {
    my $sum = 0;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            if ($map[$i][$j] == 0) {
                $sum += get_paths($i, $j);
            }
        }
    }
    print("part1: $sum \n");
}

part1();

sub get_ratings {
    my ($start_x, $start_y) = @_;
    my @queue = ( [$start_x, $start_y] );

    my $rating = 0;

    while (@queue) {
        my ($x, $y) = @{shift @queue};
        $rating++ if $map[$x][$y] == 9;
        for my $dir (@directions) {
            my ($dx, $dy) = @$dir;
            my ($new_x, $new_y) = ($x + $dx, $y + $dy);
            if ($new_x >= 0 && $new_x <= $#map &&
                $new_y >= 0 && $new_y <= $#{$map[0]} &&
                ($map[$new_x][$new_y] - $map[$x][$y] == 1)
            ) {
                push @queue, [$new_x, $new_y];
            }
        }
    }
    return $rating;
}

sub part2 {
    my $sum = 0;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            if ($map[$i][$j] == 0) {
                $sum += get_ratings($i, $j);
            }
        }
    }
    print("part2: ", $sum, "\n");
}

part2();
