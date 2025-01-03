#!/opt/local/bin/perl
use strict;
use warnings;
#use Memoize;

my $filename = 'sample1.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @moves;
my @grid;
my @grid2;
my $l=0;
my ($start_x, $start_y);
my ($end_x, $end_y);

while(my $line = <$fh>) {
    chomp $line;
    my @list = split //, $line;
    my @start_index = grep { $list[$_] eq 'S' } 0 .. $#list;
    if (@start_index) {
        $start_x=$l;
        $start_y=$start_index[0];
    }
    my @end_index = grep { $list[$_] eq 'E' } 0 .. $#list;
    if (@end_index) {
        $end_x=$l;
        $end_y=$end_index[0];
    }
    push @grid, \@list;
    $l++;
}

close $fh;

sub print_grid {
    for my $i (0 .. $#grid) {
        for my $j (0 .. $#{$grid[0]}) {
            print($grid[$i][$j]);
        }
        print("\n");
    }
}


my @directions = ([0, 1], [1, 0], [0, -1], [-1, 0]);
my @dir = ('>', 'v', '<', '^');
my $min_score = 10000000000000;

sub shortest_path {
    my @queue = ( [$start_x, $start_y, 0, []] );
    my %visited;
    $visited{"$start_x,$start_y"} = 1;

    while (@queue) {
        my ($x, $y, $steps, $path) = @{shift @queue};

        my @current_path = (@$path, [$x, $y]);

        return ($steps, \@current_path) if $x == $end_x && $y == $end_y;

        for my $dir (@directions) {
            my ($dx, $dy) = @$dir;
            my ($new_x, $new_y) = ($x + $dx, $y + $dy);

            if ($new_x >= 0 && $new_x <= 3 &&
                $new_y >= 0 && $new_y <= 2 &&
                !$visited{"$new_x,$new_y"}) {

                push @queue, [$new_x, $new_y, $steps + 1, \@current_path];
                $visited{"$new_x,$new_y"} = 1;
            }
        }
    }
    return (-1, []);
}
# sub dfs {
#     my ($x, $y, $path, $visited, $paths) = @_;
#
#     if ($x == $end_x && $y == $end_y) {
#         my $turns = calculate_turns($path);
#         print("turns: $turns \n");
#         my $score = $turns*1000 + $#$path;
#         if ($score < $min_score) {
#             $min_score=$score;
#         }
#         print join("", @$path), "\n";
#         return;
#     }
#
#
#     $visited->{"$x,$y"} = 1;
#
#     for my $i (0 .. $#directions) {
#         if($#$path == 1 && $i == 2 ) {
#             next;
#         }
#         my ($nx, $ny) = ($x + $directions[$i][0], $y + $directions[$i][1]);
#         if ($nx > 0 && $ny > 0 && $nx < $#grid && $ny < $#{$grid[0]} &&
#             $grid[$nx][$ny] ne '#' && !$visited->{"$nx,$ny"}) {
#
#             push @$path, $dir[$i];
#             dfs($nx, $ny, $path, $visited, $paths);
#             pop @$path;
#         }
#     }
#     delete $visited->{"$x,$y"};
# }

sub calculate_turns {
    my ($path) = @_;
    my $turns = 0;

    for my $i (1 .. $#$path) {
        my ($prev, $curr) = ($path->[$i - 1], $path->[$i]);
        if (($prev eq '>' || $prev eq '<') && ($curr eq '^' || $curr eq 'v')) {
            $turns++;
        } elsif (($prev eq '^' || $prev eq 'v') && ($curr eq '>' || $curr eq '<')) {
            $turns++;
        }
    }
    return $turns;
}

#dfs($start_x, $start_y, ['>'], {});
my ($steps, @path) =  shortest_path();
print("steps: $steps \n");
print("min_score: $min_score \n");

print_grid();



