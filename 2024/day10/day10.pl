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
    #print("num paths: ", $num_paths, "\n");
    return $num_paths;
}

sub get_ratings {
    my ($start_x, $start_y, $visited_ref, $rating ) = @_;
    my %visited = %$visited_ref;
    if ($map[$start_x][$start_y] == 9) {
        $rating++;
    }

    $visited{"$start_x,$start_y"} = 1;

    for my $dir (@directions) {
        my ($dx, $dy) = @$dir;
        my ($new_x, $new_y) = ($start_x + $dx, $start_y + $dy);
        if ($new_x >= 0 && $new_x <= $#map &&
            $new_y >= 0 && $new_y <= $#{$map[0]} &&
            !$visited{"$new_x,$new_y"} &&
            ($map[$new_x][$new_y] - $map[$start_x][$start_y] == 1)
        ) {
            $rating = get_ratings($new_x, $new_y, \%visited, $rating);
        }
    }
    print("rating: ", $rating, "\n");
    return $rating;
}

my $sum = 0;
# for my $i (0 .. $#map) {
# 	for my $j (0 .. $#{$map[$i]}) {
#         if ($map[$i][$j] == 0) {
#             $sum += get_paths($i, $j);
#         }
# 	}
# }


my %visited;
my $rating = 0;
my $result = get_ratings(0, 2, \%visited, $rating);
print("rating: ", $result, "\n");
# for my $i (0 .. $#map) {
# 	for my $j (0 .. $#{$map[$i]}) {
#         if ($map[$i][$j] == 0) {
#             last;
#         }
# 	}
# }



print("sum : ", $sum, "\n");
