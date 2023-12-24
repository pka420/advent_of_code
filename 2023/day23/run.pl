#!/bin/perl
use List::MoreUtils 'first_index';

my $file_path = @ARGV[0];
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";

my @map;
while (my $line = <$file_handle>) {
    chomp $line;
    my @chars = split '', $line;
    push @map, \@chars;
}

# for my $row (@map) {
#     for my $element (@$row) {
#         print "$element ";
#     }
#     print "\n";
# }


sub findAllHikes {
    my ($curr, $path, $seen, $map) = @_;
    my $row = scalar(@map);
    my $col = scalar(@{$map[0]});
    my $x = $curr->[0];
    my $y = $curr->[1];

    # print "curr: $x $y \n";

    if ( $x < 0 || $y < 0 || $x > $row-1 || $y > $col-2 || $map[$x][$y] eq '#' || $seen[$x][$y] == 1 ) {
        return;
    }

    push @path, $curr;
    $seen[$x][$y] = 1;

    if ($x == $row - 1 && $y == $col - 2 ) {
        my $len = scalar(@$path)-1;
        print "Found a path with length: $len  \n";
    } else {
        my $dir = $map[$x][$y];
        if ($dir eq 'v') {
            findAllHikes([$x + 1, $y], \@path, \@seen, \@map); # Go down
        } elsif ($dir eq '>') {
            findAllHikes([$x, $y + 1], \@path, \@seen, \@map); # Go right
        } elsif ($dir eq '<') {
            findAllHikes([$x, $y - 1], \@path, \@seen, \@map); # Go left
        } elsif ($dir eq '^') {
            findAllHikes([$x - 1, $y], \@path, \@seen, \@map); # Go up
        }
        else {
            my @directions = ([1, 0], [0, 1], [0, -1], [-1, 0]);
            foreach my $d (@directions) {
                findAllHikes([$x + $d->[0], $y + $d->[1]], \@path, \@seen, \@map);
            }
        }
    }

    pop @path;
    $seen[$x][$y] = 0;
}

sub findAllHikes_part2 {
    my ($curr, $path, $seen, $map) = @_;
    my $row = scalar(@map);
    my $col = scalar(@{$map[0]});
    my $x = $curr->[0];
    my $y = $curr->[1];

    # print "curr: $x $y \n";

    if ( $x < 0 || $y < 0 || $x > $row-1 || $y > $col-2 || $map[$x][$y] eq '#' || $seen[$x][$y] == 1 ) {
        return;
    }

    push @path, $curr;
    $seen[$x][$y] = 1;

    if ($x == $row - 1 && $y == $col - 2 ) {
        my $len = scalar(@$path)-1;
        print "Found a path with length: $len  \n";
    } else {
            my @directions = ([1, 0], [0, 1], [0, -1], [-1, 0]);
            foreach my $d (@directions) {
                findAllHikes_part2([$x + $d->[0], $y + $d->[1]], \@path, \@seen, \@map);
            }
    }

    pop @path;
    $seen[$x][$y] = 0;
}


my $start = [0, 1];
print "Start: $start->[0] $start->[1] \n";

my @path = ();
my @allPaths = ();
my $row = scalar(@map);
my $col = scalar(@{$map[0]});
my @seen = map [ (0) x $col ], 1..$row;

findAllHikes($start, \@path, \@seen, \@map);

my @lens = ();
print "number of paths found: " . scalar(@allPaths) . "\n";
foreach my $p (@allPaths) {
    push @lens, scalar(@$p);
}

my @maxlens = reverse sort @lens;
print "max length: $maxlens[0] \n";
