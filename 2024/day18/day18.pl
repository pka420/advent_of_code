#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input1.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my $rows = 71;
my $cols = 71;
# my $rows = 71;
# my $cols = 71;
my @grid;
my @x;
my @y;
for my $i (0 .. $rows) {
    my @list;
    for my $j (0 .. $cols) {
        push @list, '.';
    }
    push @grid, \@list;
}
while(my $line = <$fh>) {
    chomp $line;
    if($line =~ /(\d+),(\d+)/) {
        $grid[$2][$1] = "#";
    }
}

close $fh;

for my $i (0 .. $rows-1 ) {
    for my $j (0 .. $cols-1) {
        print($grid[$i][$j]);
    }
    print("\n");
}

my @directions = ([1,0], [-1,0], [0,1], [0,-1] );

sub shortest_path {
    my ($start_x, $start_y) = @_;
    my @queue = ( [$start_x, $start_y, 0, []] );
    my %visited;
    $visited{"$start_x,$start_y"} = 1;

    while (@queue) {
        my ($x, $y, $steps, $path) = @{shift @queue};

        return $steps if $x == $rows-1 && $y == $cols-1;

        for my $dir (@directions) {
            my ($dx, $dy) = @$dir;
            my ($new_x, $new_y) = ($x + $dx, $y + $dy);

            if ($new_x >= 0 && $new_x < $rows &&
                $new_y >= 0 && $new_y < $cols &&
                !$visited{"$new_x,$new_y"} &&
                $grid[$new_x][$new_y] ne '#') {

                push @queue, [$new_x, $new_y, $steps + 1];
                $visited{"$new_x,$new_y"} = 1;
            }
        }
    }
    return -1;
}

my $steps=0;
$steps = shortest_path(0, 0);
print("steps $steps \n");

$filename = 'input2.txt';
open($fh, '<', $filename) or die "Could not open file '$filename': $!";

while(my $line = <$fh>) {
    chomp $line;
    if($line =~ /(\d+),(\d+)/) {
        $grid[$2][$1] = "#";
        $steps = shortest_path(0, 0);
        if ($steps == -1) {
            print("steps $steps at $1,$2 \n");
            last;
        }
    }
}

close $fh;
