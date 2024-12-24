#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample4.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @map;

while (my $line = <$fh>) {
    chomp $line;
		my @list = split //, $line;
		push @map, \@list;
}

close $fh;

my $rows = scalar @map;
my $cols = scalar @{$map[0]};

for my $i ( 0 .. $rows-1) {
    for my $j ( 0 .. $cols-1) {
        print $map[$i][$j];
    }
    print("\n");
}
print("\n");
print("\n");

my @directions = ( [1, 0], [-1, 0], [0, 1], [0, -1] );

sub explore_region {
    my ($row, $col, $char, $visited) = @_;
    

    return (0, 1) if $row < 0 || $row >= $rows || $col < 0 || $col >= $cols; 
    return (0, 0) if $visited->{"$row,$col"};
    return (0, 1) if $map[$row][$col] ne $char;  

    $map[$row][$col] = '-';
    $visited->{"$row,$col"} = 1;

    my $area = 1;
    my $perimeter = 0;

    foreach my $dir (@directions) {
        my $new_row = $row + $dir->[0];
        my $new_col = $col + $dir->[1];
        
        my ($d_area, $d_perimeter) = explore_region($new_row, $new_col, $char, $visited);
        $area += $d_area;
        $perimeter += $d_perimeter;
    }
    return ($area, $perimeter);
}

sub part1 {
    my %area;
    my %perimeter;
    my $sum = 0;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            my $char = $map[$i][$j];
            if ($char ne '-') {
                my %visited;
                my ($ar, $pr) = explore_region($i, $j, $char, \%visited);
                $sum += $ar*$pr;
                $area{$char} += $ar;
                $perimeter{$char} += $pr;
            }
        }
    }
    print("sum: ", $sum, "\n");
# for my $char (keys %area) {
#     print "$char area => $area{$char}, perimeter => $perimeter{$char} \n";
# }
#
}

sub explore_region2 {
    my ($row, $col, $char, $visited) = @_;
    
    return (0, 0) if $row < 0 || $row >= $rows || $col < 0 || $col >= $cols; 
    return (0, 0) if $visited->{"$row,$col"};
    return (0, 0) if $map[$row][$col] ne $char;  

    $map[$row][$col] = '-';
    $visited->{"$row,$col"} = 1;

    my $area = 1;
    my $sides = 4;

    foreach my $dir (@directions) {
        my $new_row = $row + $dir->[0];
        my $new_col = $col + $dir->[1];
        
        if ($new_row >= 0 && $new_row < $rows && $new_col >= 0 && $new_col < $cols && $map[$new_row][$new_col] eq $char) {
            $sides -= 3; 
        }
        my ($d_area, $d_sides) = explore_region2($new_row, $new_col, $char, $visited);
        $area += $d_area;
        $sides += $d_sides;

    }
    return ($area, $sides);
}

sub part2 {
    my %area;
    my %perimeter;
    my $sum = 0;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            my $char = $map[$i][$j];
            if ($char ne '-') {
                my %visited;
                my ($ar, $pr) = explore_region2($i, $j, $char, \%visited);
                # print("visited for $char \n");
                # for my $element (keys %visited) {
                #     print "$element, ";
                # }
                # print("\n");
                if ($pr > 4) {
                    $pr -= 4;
                }
                 
                $sum += $ar*$pr;

                $area{$char} += $ar;
                $perimeter{$char} += $pr;
            }
        }
    }
    print("sum: ", $sum, "\n");
    for my $char (keys %area) {
        print "$char area => $area{$char}, perimeter => $perimeter{$char} \n";
    }
}
part2();
