#!/opt/local/bin/perl
use strict;
use warnings;
my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @map;
my @guard;
my $symbol = '^';
my $flag = 0;

while (my $line = <$fh>) {
    chomp $line;
    my @list = split //, $line;
    my @index = grep { $list[$_] eq $symbol } 0..$#list;
    if ( @index ) {
        push @guard, $#map+1;
        push @guard, @index;
    }
    push @map, \@list;
}

close $fh;


sub calc_next_pos {
    my ($symbol, @cur_position) = @_;
    if ( $symbol eq '^') {
        $cur_position[0] = $cur_position[0] - 1;
    } elsif ( $symbol eq '>') {
        $cur_position[1] = $cur_position[1] + 1;
    } elsif ( $symbol eq '<') {
        $cur_position[1] = $cur_position[1] - 1;
    } else {
        $cur_position[0] = $cur_position[0] + 1;
    }
    return @cur_position;
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

sub check_loop {
    my @cur_pos = @guard;
    my $symbol = $map[$cur_pos[0]][$cur_pos[1]];
    my $flag = 0;
    my $iterations = 0;
    while ($flag != 1 && $iterations<100000) {
        my @next_pos = calc_next_pos($symbol, @cur_pos);
        if ($next_pos[0] < 0 || $next_pos[0] > $#map ||
            $next_pos[1] < 0 || $next_pos[1] > $#{$map[0]} ) {
            $flag = 1; #exit
        }
        elsif ($map[$next_pos[0]][$next_pos[1]] eq '#') {
            $symbol = calc_next_symbol($symbol);
        } else {
            @cur_pos = @next_pos;
        }
        $iterations++;
    }
    return $flag;
}

sub part1 {
    my @cur_pos = @guard;
    while ($flag != 1) {
        $map[$cur_pos[0]][$cur_pos[1]] = 'X';
        my @next_pos = calc_next_pos($symbol, @cur_pos);
        if ($next_pos[0] < 0 || $next_pos[0] > $#map ||
            $next_pos[1] < 0 || $next_pos[1] > $#{$map[0]} ) {
            $flag = 1;
        }
        elsif ($map[$next_pos[0]][$next_pos[1]] eq '#') {
            $symbol = calc_next_symbol($symbol);
        } else {
            @cur_pos = @next_pos;
        }
    }

    my $count = 0;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            print($map[$i][$j]);
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
    my $count = 0;
    my %seen;
    my @cur_pos = @guard;
    while ($flag != 1) {
        $seen{"$cur_pos[0],$cur_pos[1]"} = 0;
        my @next_pos = calc_next_pos($symbol, @cur_pos);
        if ($next_pos[0] < 0 || $next_pos[0] > $#map ||
            $next_pos[1] < 0 || $next_pos[1] > $#{$map[0]} ) {
            $flag = 1;
        }
        elsif ($map[$next_pos[0]][$next_pos[1]] eq '#') {
            $symbol = calc_next_symbol($symbol);
        } else {
            @cur_pos = @next_pos;
        }
    }
    delete $seen{"$guard[0],$guard[1]"};
    print("guard at $guard[0], $guard[1] \n");
    foreach my $key (sort keys %seen) {
        my ($x, $y) = split /,/, $key;
        $map[$x][$y] = '#';
        my $result = check_loop();
        if ($result == 0) {
            #print("found loop at $x, $y \n");
            $count++;
        }
        $map[$x][$y] = '.';
    }
    print("Part 2: ", $count, "\n");
}

part2();
