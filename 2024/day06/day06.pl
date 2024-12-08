#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @map;
my @guard;
my $symbol = '^';
my $flag = 0; #flag that guard is done.

while (my $line = <$fh>) {
    chomp $line;
    my @list = split //, $line;
    my @index = grep { $list[$_] eq $symbol } 0..$#list;
    if ( @index ) {
        push @guard, $#map;
        push @guard, @index;
    }
    push @map, \@list;
}

close $fh;


sub calc_next_pos {
    my ($symbol, @guard) = @_;
    if ( $symbol eq '^') {
        $guard[0] = $guard[0] - 1;
    } elsif ( $symbol eq '>') {
        $guard[1] = $guard[1] + 1;
    } elsif ( $symbol eq '<') {
        $guard[1] = $guard[1] - 1;
    } else {
        $guard[0] = $guard[0] + 1;
    }
    return @guard;
}
sub calc_next_symbol {
    my ($symbol) = @_;
    my $next_symbol = '^';
    if ( $symbol eq '^') {
        $next_symbol = '>';
    } elsif ( $symbol eq '>') {
        $next_symbol = 'v';
    } elsif ( $symbol eq 'v') {
        $next_symbol = '<';
    } else {
        $next_symbol = '^';
    }
    return $next_symbol;
}

sub part1 {
    while ($flag != 1) {
        $map[$guard[0]][$guard[1]] = 'X';
        my @next_pos = calc_next_pos($symbol, @guard);
        if ($next_pos[0] < 0 || $next_pos[0] > $#map ||
            $next_pos[1] < 0 || $next_pos[1] > $#{$map[0]} ) {
            $flag = 1;
        }
        elsif ($map[$next_pos[0]][$next_pos[1]] eq '#') {
            $symbol = calc_next_symbol($symbol);
        } else {
            @guard = @next_pos;
        }
    }

    my $count = 0;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            print($map[$i][$j], " ");
            if ( $map[$i][$j] eq 'X') {
                $count++;
            }
        }
        print("\n");
    }

    print("Part 1: ", $count, "\n");
}

sub part2 {
    $flag=0;
    while ($flag != 1) {
        $map[$guard[0]][$guard[1]] = 'X';
        my @next_pos = calc_next_pos($symbol, @guard);
        if ($next_pos[0] < 0 || $next_pos[0] > $#map ||
            $next_pos[1] < 0 || $next_pos[1] > $#{$map[0]} ) {
            $flag = 1;
        }
        elsif ($map[$next_pos[0]][$next_pos[1]] eq '#') {
            $symbol = calc_next_symbol($symbol);
        } else {
            @guard = @next_pos;
        }
    }

    my $count = 0;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            print($map[$i][$j], " ");
            if ( $map[$i][$j] eq 'X') {
                $count++;
            }
        }
        print("\n");
    }

    print("Part 2: ", $count, "\n");
}


part1();
