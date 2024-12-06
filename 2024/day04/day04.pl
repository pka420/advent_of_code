#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @array;

while (my $line = <$fh>) {
    chomp $line;
    my @chars = split //, $line;
    push @array, \@chars;
}

close $fh;

my $count = 0;
my @dir = ([-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1]);
my $stir = "XMAS";
my @word = split //, $stir;
my $n = 1;

foreach my $i (0 .. $#array) {
	foreach my $j (0 .. $#{$array[$i]}) {
		if ($array[$i][$j] =~ "X") {
			foreach my $k (0 .. $#dir) {
                my $x = $i + $dir[$k][0];
                my $y = $j + $dir[$k][1];
				while($n <= $#word && $x >= 0 && $y >= 0 && $x <= $#array && $y <= $#{$array[$i]}) {
					if($array[$x][$y] ne $word[$n]) {
						last;
					}
                    elsif($n == 3) {
                        $count++;
						last;
                    }
					$n++;
                    $x = $x + $dir[$k][0];
                    $y = $y + $dir[$k][1];
				}
				$n=1;
			}
		}
	}
}

print("Part 1 : ", $count);
print("\n");

$count=0;
$n=0;
@word = ("A", "S");
my @dir1 = ([-1,-1], [1,1]);
my @dir2 = ([1,-1], [-1,1]);
my $x1;
my $x2;
my $y1;
my $y2;
my $flag=0;

foreach my $i (0 .. $#array) {
	foreach my $j (0 .. $#{$array[$i]}) {
		if ($array[$i][$j] =~ "A") {
            # check dir1
            $x1 = $i + $dir1[0][0];
            $y1 = $j + $dir1[0][1];
            $x2 = $i + $dir1[1][0];
            $y2 = $j + $dir1[1][1];
            if ($x1>=0 && $y1>=0 && $x2>=0 && $y2>=0 && $x1<=$#array && $x2<= $#array && $y1<=$#{$array[$i]} && $y2<=$#{$array[$i]}) {
                if( ($array[$x1][$y1] eq 'S' && $array[$x2][$y2] eq 'M') ||
                    ($array[$x1][$y1] eq 'M' && $array[$x2][$y2] eq 'S') ) {
                    $flag++;
                } else {
                    $flag=0;
                }
            }
            # check dir2
            $x1 = $i + $dir2[0][0];
            $y1 = $j + $dir2[0][1];
            $x2 = $i + $dir2[1][0];
            $y2 = $j + $dir2[1][1];
            if ($x1>=0 && $y1>=0 && $x2>=0 && $y2>=0 && $x1<=$#array && $x2<= $#array && $y1<=$#{$array[$i]} && $y2<=$#{$array[$i]}) {
                if( ($array[$x1][$y1] eq 'S' && $array[$x2][$y2] eq 'M') ||
                    ($array[$x1][$y1] eq 'M' && $array[$x2][$y2] eq 'S') ) {
                    $flag++;
                } else {
                    $flag=0;
                }
            }
            if ($flag == 2) {
                $count++;
            }
            $flag=0;
		}
	}
}

print("Part 2 : ", $count);
print("\n");
