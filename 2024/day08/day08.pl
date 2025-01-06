#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @map;

while (my $line = <$fh>) {
    chomp $line;
		my @list = split //, $line;
		push @map, \@list;
}

close $fh;

my %antennas;
for my $i (0 .. $#map) {
	for my $j (0 .. $#{$map[$i]}) {
        if($map[$i][$j] ne '.') {
            push @{$antennas{$map[$i][$j]}}, [$i, $j];
        }
	}
}

# foreach my $key (keys %antennas) {
#     print("antenna $key at locations:\n");
#     print(join(", ", map {"($_->[0], $_->[1])"} @{$antennas{$key}}));
#     print("\n");
# }

my $rows = $#map;
my $cols = $#{$map[0]};

my %antinodes;
foreach my $key (keys %antennas) {
    my @coordinates = @{$antennas{$key}};
    for my $i ( 0 .. $#coordinates) {
        for my $j ( $i+1 .. $#coordinates) {
            my ($r1, $c1) = ($coordinates[$i][0], $coordinates[$i][1]);
            my ($r2, $c2) = ($coordinates[$j][0], $coordinates[$j][1]);
            my $x = 2*$r2-$r1;
            my $y = 2*$c2-$c1;
            if ($x >= 0 && $x <= $rows && $y >= 0 && $y <= $cols) {
                $antinodes{"$x,$y"} = 0;
            }
            $x = 2*$r1-$r2;
            $y = 2*$c1-$c2;
            if ($x >= 0 && $x < $rows && $y >= 0 && $y <= $cols) {
                $antinodes{"$x,$y"} = 0;
            }
        }
    }
}
my $size = scalar %antinodes;
print("no of antinodes: $size \n");


my %antinodes2;
foreach my $key (keys %antennas) {
    my @coordinates = @{$antennas{$key}};
    for my $i ( 0 .. $#coordinates) {
        for my $j ( 0 .. $#coordinates) {
            next if $i == $j;
            my ($r1, $c1) = ($coordinates[$i][0], $coordinates[$i][1]);
            my ($r2, $c2) = ($coordinates[$j][0], $coordinates[$j][1]);
            my $dr = $r2-$r1;
            my $dc = $c2-$c1;
            my $x = $r1;
            my $y = $c1;
            while(0 <= $x <= $rows && 0 <= $y <= $cols) {
                $antinodes2{"$x,$y"} = 0;
                $x += $dr;
                $y += $dc;
            }
        }
    }
}
$size = scalar %antinodes2;
print("no of antinodes part2: $size \n");
