#!/bin/perl
use strict;
# use PDL;
# use PDL::LinearAlgebra;
use Math::MatrixReal;
use Math::Symbolic qw/:all/;




my $file_path = @ARGV[0];
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";


my $min = 7;
my $max = 27;
if ( $file_path =~ /input/ ) {
    $min = 200000000000000;
    $max = 400000000000000;
}

my @list1;
my @list2;
while (my $line = <$file_handle>) {
    chomp $line;
    my @row = split /@/, $line;
    push @list1, $row[0];
    push @list2, $row[1];
}

close $file_handle;

sub find_intersection {
    my ($x1, $y1, $vx1, $vy1, $x2, $y2, $vx2, $vy2) = @_;

    my $m1 = $vy1 / $vx1;
    my $m2 = $vy2 / $vx2;
    if ($m1 == $m2) {
        return 0;
    }
    my $x = ($y2 - $y1 + $m1 * $x1 - $m2 * $x2) / ($m1 - $m2);
    if ($x > $max || $x < $min) {
        return 0;
    }
    my $y = $m1 * ($x - $x1) + $y1;
    if ($y > $max || $y < $min) {
        return 0;
    }
    my $dx = [$x - $x1, $x - $x2];
    my $dy = [$y - $y1, $y - $y2];
    if ( $vx1*$dx->[0] < 0 || $vx2*$dx->[1] < 0 || $vy1*$dy->[0] < 0 || $vy2*$dy->[1] < 0) {
        return 0;
    }
    print "intersection $x, $y found b/w lines $x1, $y1 and $x2, $y2\n";

    return 1;
}
sub sovle_part1 {
    my $count = 0;

    for my $i (0 .. $#list1-1) {
        my @pts1 = split /,/, $list1[$i];
        my @dirs1 = split /,/, $list2[$i];

        for my $j ($i .. $#list1-1) {
            my @pts2 = split /,/, $list1[$j+1];
            my @dirs2 = split /,/, $list2[$j+1];
            if (find_intersection($pts1[0], $pts1[1], $dirs1[0], $dirs1[1], $pts2[0], $pts2[1], $dirs2[0], $dirs2[1]) == 1) {
                $count++;
            }
        }
    }

    print "count: $count\n";
}

#sovle_part1();
#

sub solve_part2 {
    for my $i (0 .. $#list1-1) {
        my @pts1 = split /,/, $list1[$i];
        my @pts2 = split /,/, $list1[$i+1];
        my @dirs1 = split /,/, $list2[$i];
        my @dirs2 = split /,/, $list2[$i+1];

        my $xh = $pts1[0];
        my $yh = $pts1[1];
        my $zh = $pts1[2];

        my $vxh = $dirs1[0];
        my $vyh = $dirs1[1];
        my $vzh = $dirs1[2];

        my ($xr, $yr, $zr, $vxr, $vyr, $vzr);

        my $eq1 = Math::Symbolic->parse_from_string("(xr-xh)*(vyh-vyr) - (vxh-vxr)*(yr-yh)");
        my $eq2 = Math::Symbolic->parse_from_string("(yr-yh)*(vzh-vzr) - (vyh-vyr)*(zr-zh)");
        Math::Symbolic::
        my $sol1 = Math::Symbolic::Solver::solve($eq1, $xr);
        my $sol2 = Math::Symbolic::Solver::solve($eq2, $yr);
        print "sol1: $sol1\n";
        print "sol2: $sol2\n";
    }
}

solve_part2();





