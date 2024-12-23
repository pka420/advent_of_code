#!/opt/local/bin/perl
use strict;
use warnings;
use List::Util qw(min);

my @map = ( [7,8,9], [4,5,6], [1,2,3], [-1, 0,'A'] );

my @dir_map = ( [-1, '^', 'A'], ['<', 'v', '>'] );

my @directions = ( [1, 0], [-1, 0], [0, 1], [0, -1] );

my @code = ('029A', '980A');

sub find_coordinates {
    my ($num) = @_;
    return (3,2) if $num eq 'A';
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            return ($i, $j) if $map[$i][$j] =~ /^\d+$/ && $map[$i][$j] == $num;
        }
    }
    die "Number $num not found in the map.\n";
}

sub shortest_path {
    my ($start_x, $start_y, $end_x, $end_y) = @_;
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

sub find_direction {
    my ($delta) = @_;

    return '^' if $delta->[0] == -1 && $delta->[1] == 0;
    return '<' if $delta->[0] == 0 && $delta->[1] == -1;
    return 'v' if $delta->[0] == 1 && $delta->[1] == 0;
    return '>' if $delta->[0] == 0 && $delta->[1] == 1;

    die "Direction $delta not found.\n";
}

sub find_coordinates_directions {
    my ($dir) = @_;
    return (0,2) if $dir eq 'A';
    return (0,1) if $dir eq '^';
    return (1,0) if $dir eq '<';
    return (1,1) if $dir eq 'v';
    return (1,2) if $dir eq '>';
    die "Direction $dir not found in the map.\n";
}

sub shortest_path_directions {
    my ($start_x, $start_y, $end_x, $end_y) = @_;
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

            if ($new_x >= 0 && $new_x <= 1 &&
                $new_y >= 0 && $new_y <= 2 &&
                !$visited{"$new_x,$new_y"}) {

                push @queue, [$new_x, $new_y, $steps + 1, \@current_path];
                $visited{"$new_x,$new_y"} = 1;
            }
        }
    }
    return (-1, []);
}


sub part1 {
    my $complexity = 0;
    my $len = 0;

    my @co = split //, $code[0];

    my $start_x = 3;
    my $start_y = 2;
    my $dir_start_x = 0;
    my $dir_start_y = 2;
    my @directions_path;
    for my $i (0 .. $#co) {
        # print("going to ", $co[$i], "\n");
        my ($end_x, $end_y) = find_coordinates($co[$i]);
        # print("end x ", $end_x, "\n");
        # print("end y ", $end_y, "\n");
        my ($res, $path) = shortest_path($start_x, $start_y, $end_x, $end_y);
        if ($res != -1) {
            # print("len of getting to ", $co[$i], " : ", $res, "\n");
            # print "Path: ", join(" -> ", map { "($_->[0], $_->[1])" } @$path), "\n";
            for my $j ( 0 .. $#$path-1) {
                my ($x1, $y1) = @{$path->[$j]};
                my ($x2, $y2) = @{$path->[$j+1]};

                my $dx = $x2 - $x1;
                my $dy = $y2 - $y1;

                my $dir = find_direction([$dx, $dy]);
                push @directions_path, $dir;
                my ($dir_end_x, $dir_end_y) = find_coordinates_directions($dir);

                # my ($dir_res, $dir_path) = shortest_path_directions($dir_start_x, $dir_start_y, $dir_end_x, $dir_end_y);
                #
                # print "Path: ", join(" -> ", map { "($_->[0], $_->[1])" } @$dir_path), "\n";

                $dir_start_x = $dir_end_x;
                $dir_start_y = $dir_end_y;
            }
            push @directions_path, 'A';

        } else {
            print("no path found", "\n");
            exit 1;
        }
        $start_x = $end_x;
        $start_y = $end_y;
    }
    print "Path: ", join("", @directions_path), "\n";

    print("Complexity: ", $complexity, "\n");
}

part1()
