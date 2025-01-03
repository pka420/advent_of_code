#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample.txt';
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

sub is_vertex {
    my ($row, $col) = @_;
    my $char = $map[$row][$col];


    my $top = ($row > 0) ? $map[$row-1][$col] : undef;
    my $bottom = ($row < $rows-1) ? $map[$row+1][$col] : undef;
    return 0 if defined $top && defined $bottom && $top eq $char && $bottom eq $char;

    my $left = ($col > 0) ? $map[$row][$col-1] : undef;
    my $right = ($col < $cols-1) ? $map[$row][$col+1] : undef;
    return 0 if defined $left && defined $right && $left eq $char && $right eq $char;

    return 1;
}


sub explore_region2 {
    my ($row, $col, $char, $visited) = @_;
    
    return (0,0) if $row < 0 || $row >= $rows || $col < 0 || $col >= $cols; 
    return (0,0) if $visited->{"$row,$col"};
    return (0,0) if $map[$row][$col] ne $char;  

    $visited->{"$row,$col"} = 1;

    my $area = 1;
    my $bounds = is_vertex($row, $col);

    foreach my $dir (@directions) {
        my $new_row = $row + $dir->[0];
        my $new_col = $col + $dir->[1];
        
        my ($d_area, $d_bounds) = explore_region2($new_row, $new_col, $char, $visited);
        $area += $d_area;
        $bounds += $d_bounds;
    }
    return ($area, $bounds);
}

sub part2 {
    my %area;
    my %sides;
    my $sum = 0;
    my %visited;
    for my $i (0 .. $#map) {
        for my $j (0 .. $#{$map[$i]}) {
            my $char = $map[$i][$j];
            if ($char ne '-') {
                my ($ar, $sd) = explore_region2($i, $j, $char, \%visited );

                $sum += $ar*$sd;

                $area{$char} += $ar;
                $sides{$char} += $sd;
                print "$char area => $ar, sides => $sd \n";
            }
        }
    }
    print("sum: ", $sum, "\n");
    for my $char (keys %area) {
        print "$char area => $area{$char}, sides => $sides{$char} \n";
    }
}
part2();
