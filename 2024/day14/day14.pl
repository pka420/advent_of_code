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

    my $safety = $quadrants[0]*$quadrants[1]*$quadrants[2]*$quadrants[3];
    print("safety_factor: $safety \n");
    return $safety;
}

#part1();

sub part2 {
    my $seconds = 1;
    my $flag = 1;
    my $mid_w = int(($width-1)/2);
    my $mid_h = int(($height-1)/2);
    my $min_safety = 130686500;
    # previous answer's changed 2 to 1.
    my $best_seconds = $seconds;

    my $x;
    my $y;
    while($seconds < 10000) {
        my @quadrants = (0,0,0,0);
        for my $i (0 .. $#position) {
            ($x, $y) = ($position[$i][0], $position[$i][1]);
            my ($vx, $vy) = ($velocity[$i][0], $velocity[$i][1]);

            $x = ($x + $vx*$seconds)%$width;
            $y = ($y + $vy*$seconds)%$height;
            $quadrants[0]++ if $x < $mid_w && $y < $mid_h;
            $quadrants[1]++ if $x < $mid_w && $y > $mid_h;
            $quadrants[2]++ if $x > $mid_w && $y < $mid_h;
            $quadrants[3]++ if $x > $mid_w && $y > $mid_h;
        }
        my $safe = $quadrants[0]*$quadrants[1]*$quadrants[2]*$quadrants[3];
        #print("After $seconds seconds: $safe\n");
        if ( $safe < $min_safety){
            $min_safety = $safe;
            $best_seconds = $seconds;
        }

        $seconds++;
    }
    print("$min_safety at $best_seconds\n");

}
part2();
