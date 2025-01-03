#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @moves;
my @grid;
my @grid2;
my $l=0;
my ($start_x, $start_y);
while(my $line = <$fh>) {
    chomp $line;
    if($line =~ /^\s*$/ ) {
        while(my $line2 = <$fh>) {
            chomp $line2;
            push @moves, split //, $line2;
        }
        last;
    }
    my @list = split //, $line;
    my @index = grep { $list[$_] eq '@' } 0 .. $#list;
    if (@index) {
        $start_x=$l;
        $start_y=$index[0];
    }
    push @grid, \@list;
    $l++;
}


print(join("", @moves), "\n");

sub make_grid_double {
    for my $i (0 .. $#grid) {
        my $line = "";
        for my $j (0 .. $#{$grid[0]}) {
            if ($grid[$i][$j] eq '#') {
                $line .= "##";
            } elsif ($grid[$i][$j] eq '.') {
                $line .= "..";
            } elsif ($grid[$i][$j] eq '@') {
                $line .= "@.";
            } elsif ($grid[$i][$j] eq 'O') {
                $line .= "[]";
            }
        }
        my @list = split //, $line;
        my @index = grep { $list[$_] eq '@' } 0 .. $#list;
        if (@index) {
            $start_y=$index[0];
        }
        push @grid2, \@list;
    }
}

sub print_grid {
    for my $i (0 .. $#grid) {
        for my $j (0 .. $#{$grid[0]}) {
            print($grid[$i][$j]);
        }
        print("\n");
    }
}
sub print_grid2 {
    for my $i (0 .. $#grid2) {
        for my $j (0 .. $#{$grid2[0]}) {
            print($grid2[$i][$j]);
        }
        print("\n");
    }
}

sub calculate_coordinates {
    my $sum = 0;
    for my $i (0 .. $#grid) {
        for my $j (0 .. $#{$grid[0]}) {
            if($grid[$i][$j] eq 'O') {
                $sum = $sum + $i*100 + $j;
            }
        }
    }
    print("sum of gps coordinates: $sum \n");
}

sub calculate_coordinates2 {
    my $sum = 0;
    for my $i (0 .. $#grid2) {
        for my $j (0 .. $#{$grid2[0]}) {
            if($grid2[$i][$j] eq '[') {
                $sum = $sum + $i*100 + $j;
            }
        }
    }
    print("sum of gps coordinates: $sum \n");
}

sub traverse {
    for my $i (0 .. $#moves) {
        my ($x,$y) = ($start_x, $start_y);
        if ($moves[$i] eq '>') {
            $y = $y + 1;
            if ( $grid[$x][$y] eq '#' ) {
                next;
            } elsif ($grid[$x][$y] eq 'O') {
                my $new_y=$y;
                while($grid[$x][$new_y] ne '#') {
                    if ($grid[$x][$new_y] eq '.') {
                        $grid[$start_x][$start_y] = '.';
                        $grid[$x][$y] = '@';
                        $grid[$x][$new_y] = 'O';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_y++;
                }
            } else {
                $grid[$start_x][$start_y] = '.';
                $grid[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        } elsif ($moves[$i] eq '<') {
            $y = $y - 1;
            if ( $grid[$x][$y] eq '#' ) {
                next;
            } elsif ($grid[$x][$y] eq 'O') {
                my $new_y=$y;
                while($grid[$x][$new_y] ne '#') {
                    if ($grid[$x][$new_y] eq '.') {
                        $grid[$start_x][$start_y] = '.';
                        $grid[$x][$y] = '@';
                        $grid[$x][$new_y] = 'O';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_y--;
                }
            } else {
                $grid[$start_x][$start_y] = '.';
                $grid[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        } elsif ($moves[$i] eq 'v') {
            $x = $x + 1;
            if ( $grid[$x][$y] eq '#' ) {
                next;
            } elsif ($grid[$x][$y] eq 'O') {
                my $new_x=$x;
                while($grid[$new_x][$y] ne '#') {
                    if ($grid[$new_x][$y] eq '.') {
                        $grid[$start_x][$start_y] = '.';
                        $grid[$x][$y] = '@';
                        $grid[$new_x][$y] = 'O';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_x++;
                }
            } else {
                $grid[$start_x][$start_y] = '.';
                $grid[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        } else {
            $x = $x - 1;
            if ( $grid[$x][$y] eq '#' ) {
                next;
            } elsif ($grid[$x][$y] eq 'O') {
                my $new_x=$x;
                while($grid[$new_x][$y] ne '#') {
                    if ($grid[$new_x][$y] eq '.') {
                        $grid[$start_x][$start_y] = '.';
                        $grid[$x][$y] = '@';
                        $grid[$new_x][$y] = 'O';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_x--;
                }
            } else {
                $grid[$start_x][$start_y] = '.';
                $grid[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        }
    }
}

sub traverse2 {
    for my $i (0 .. $#moves) {
        my ($x,$y) = ($start_x, $start_y);
        if ($moves[$i] eq '>') {
            $y = $y + 1;
            if ( $grid2[$x][$y] eq '#' ) {
                next;
            } elsif ($grid2[$x][$y] eq '[') {
                my $new_y=$y;
                while($grid2[$x][$new_y] ne '#') {
                    if ($grid2[$x][$new_y] eq '.') {
                        $grid2[$start_x][$start_y] = '.';
                        $grid2[$x][$y] = '@';
                        $grid2[$x][$new_y] = '[';
                        $grid2[$x][$new_y+1] = ']';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_y++;
                }
            } else {
                $grid2[$start_x][$start_y] = '.';
                $grid2[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        } elsif ($moves[$i] eq '<') {
            $y = $y - 1;
            if ( $grid2[$x][$y] eq '#' ) {
                next;
            } elsif ($grid2[$x][$y] eq 'O') {
                my $new_y=$y;
                while($grid2[$x][$new_y] ne '#') {
                    if ($grid2[$x][$new_y] eq '.') {
                        $grid2[$start_x][$start_y] = '.';
                        $grid2[$x][$y] = '@';
                        $grid2[$x][$new_y] = '[';
                        $grid2[$x][$new_y-1] = ']';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_y--;
                }
            } else {
                $grid2[$start_x][$start_y] = '.';
                $grid2[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        } elsif ($moves[$i] eq 'v') {
            $x = $x + 1;
            if ( $grid2[$x][$y] eq '#' ) {
                next;
            } elsif ($grid2[$x][$y] eq 'O') {
                my $new_x=$x;
                while($grid2[$new_x][$y] ne '#') {
                    if ($grid2[$new_x][$y] eq '.') {
                        $grid2[$start_x][$start_y] = '.';
                        $grid2[$x][$y] = '@';
                        $grid2[$new_x][$y] = 'O';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_x++;
                }
            } else {
                $grid2[$start_x][$start_y] = '.';
                $grid2[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        } else {
            $x = $x - 1;
            if ( $grid2[$x][$y] eq '#' ) {
                next;
            } elsif ($grid2[$x][$y] eq 'O') {
                my $new_x=$x;
                while($grid2[$new_x][$y] ne '#') {
                    if ($grid2[$new_x][$y] eq '.') {
                        $grid2[$start_x][$start_y] = '.';
                        $grid2[$x][$y] = '@';
                        $grid2[$new_x][$y] = 'O';
                        $start_x=$x;
                        $start_y=$y;
                        last;
                    }
                    $new_x--;
                }
            } else {
                $grid2[$start_x][$start_y] = '.';
                $grid2[$x][$y] = '@';
                $start_x=$x;
                $start_y=$y;
            }
        }
    }
}

#part1:
# traverse();
print_grid();
# calculate_coordinates();

make_grid_double();
print_grid2();
traverse2();
#calculate_coordinates2();


