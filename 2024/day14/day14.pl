#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @position;
my @velocity;
while(my $line = <$fh>) {
    chomp $line;
    if ($line =~ /p=(-?\d+),(-?\d+)\s+v=(-?\d+),(-?\d+)/) {
        my ($x, $y, $vx, $vy) = ($1, $2, $3, $4);
        push @position, [$x, $y];
        push @velocity, [$vx, $vy];
    }
}

close $fh;

my $width = 11;
my $height = 7;
$width = 101;
$height = 103;

sub part1 {

    my $mid_w = int(($width-1)/2);
    my $mid_h = int(($height-1)/2);

    my @quadrants = (0,0,0,0);

    for my $i (0 .. $#position) {
        my ($x, $y) = ($position[$i][0], $position[$i][1]);
        my ($vx, $vy) = ($velocity[$i][0], $velocity[$i][1]);

        $x = ($x + $vx*100)%$width;
        $y = ($y + $vy*100)%$height;

        $quadrants[0]++ if $x < $mid_w && $y < $mid_h;
        $quadrants[1]++ if $x < $mid_w && $y > $mid_h;
        $quadrants[2]++ if $x > $mid_w && $y < $mid_h;
        $quadrants[3]++ if $x > $mid_w && $y > $mid_h;
    }

    for my $i (0 .. 3) {
        print("quad $i: $quadrants[$i] \n");
    }

    my $safety = $quadrants[0]*$quadrants[1]*$quadrants[2]*$quadrants[3];
    print("safety_factor: $safety \n");
}

#part1();
#

sub check_christmas_tree {
    for my $i (0 .. $width) {
        for my $j (0 .. $height) {
            my $p = 0;
            for my $k (0 .. $#position) {
                if ($position[$k][0] == $i && $position[$k][1] == $j) {
                    print "#";
                    $p=1;
                    last;
                }
            }
            print "." if $p==0;
        }
        print("\n");
    }
}

sub part2 {
    my $seconds = 1;
    while($seconds<50) {
        for my $i (0 .. $#position) {
            my ($x, $y) = ($position[$i][0], $position[$i][1]);
            my ($vx, $vy) = ($velocity[$i][0], $velocity[$i][1]);

            my $seconds = 1;
            $position[$i][0] = ($x + $vx*$seconds)%$width;
            $position[$i][1] = ($y + $vy*$seconds)%$height;
            ($x, $y) = ($position[$i][0], $position[$i][1]);
        }
        print("After $seconds seconds:\n");
        last if check_christmas_tree();
        $seconds++;
    }


}
part2();
