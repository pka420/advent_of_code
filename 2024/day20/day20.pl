#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @map;
my $start_x;
my $start_y;
my $i = 0;

while (my $line = <$fh>) {
    chomp $line;
    my @list = split //, $line;
    my $start_index = grep { $list[$_] eq "S" } 0..$#list;
    if ( $start_index ) {
        $start_x = $i;
        $start_y = $start_index;
    }
	$i++;
    push @map, \@list;
}

close $fh;

my @directions = ( [1, 0], [-1, 0], [0, 1], [0, -1] );
my @jumps = ( [2, 0], [-2, 0], [0, 2], [0, -2] );

sub bfs {
    my @track;
    my @queue = ([$start_x, $start_y, 0]);
    my %visited;
    $visited{"$start_x,$start_y"} = 1;

    while (@queue) {
        my ($x, $y, $moves) = @{shift @queue};
        for my $i (0 .. $#directions) {
            my ($new_x, $new_y) = ($x + $directions[$i][0], $y + $directions[$i][1]);

            if (   $new_x >= 0
                && $new_x <= $#{$map[0]}
                && $new_y >= 0
                && $new_y <= $#map
                && !$visited{"$new_x,$new_y"}
                && $map[$new_x][$new_y] ne '#') {
                push @queue, [$new_x, $new_y, $moves + 1];
                $visited{"$new_x,$new_y"} = 1;
                push @track, [$new_x, $new_y];
                if ($map[$new_x][$new_y] eq 'E') {
                    return $moves, @track;
                }

            }
        }
    }

    return -1;
}

sub find_new_pos {
    my ($track_ref, $k, $x, $y) = @_;
    my @track = @$track_ref;
    while($k < $#track) {
        if ($track[$k][0] == $x && $track[$k][1] == $y) {
            return $k;
        }
        $k++;
    }
    return 0;
}

sub part1 {
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            print($map[$i][$j], " ");
        }
        print("\n");
    }

    print("start: ", $start_x, ",", $start_y, "\n");
    my %saved_time;

    my ($racetime, @track) = bfs();
    print("Current Racetime: ", $racetime, "\n");

    my $new_idx;
    for my $i (0 .. $#track) {
        # print($track[$i][0], ",", $track[$i][1], "->");
        for my $j ( 0 .. $#jumps) {
            $new_idx = find_new_pos(\@track, $i, $track[$i][0] + $jumps[$j][0], $track[$i][1] + $jumps[$j][1]);
            if ($new_idx != 0) {
                $racetime = abs($new_idx - $i);
                $saved_time{"$racetime"} += 1;
                print("saved time: ", $racetime, "\n");
            }
        }
    }

    print join("\n", map { "$_ ps saved by $saved_time{$_} cheats" } keys %saved_time);
    print "\n";

}

sub part2 {
}


part1();

