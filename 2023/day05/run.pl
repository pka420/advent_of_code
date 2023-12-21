#!/opt/local/bin/perl

use warnings;
use strict;
use List::MoreUtils 'first_index';

my $file_path = 'test.txt';
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";

my @list;
while (my $line = <$file_handle>) {
    chomp $line;  
    push @list, $line;
}

my @seeds;
while ( $list[0] =~ /(\d+)/ ) {
    push @seeds, $1;
    $list[0] =~ s/\d+//; 
}
#print "@seeds";

my $seed_to_soil = first_index { /seed-to-soil/ } @list;
#print "$list[$seed_to_soil] \n";

my $soil_to_fert = first_index { /soil-to-fertilizer/ } @list;
#print " $list[$soil_to_fert] \n";

my $fert_to_water = first_index { /fertilizer-to-water/ } @list;
#print " $list[$fert_to_water] \n";

my $water_to_light = first_index { /water-to-light/ } @list;
#print " $list[$water_to_light] \n";

my $light_to_temp = first_index { /light-to-temperature/ } @list;
#print " $list[$light_to_temp] \n";

my $temp_to_humid = first_index { /temperature-to-humidity/ } @list;
#print " $list[$temp_to_humid] \n";

my $humid_to_loc = first_index { /humidity-to-location/ } @list;
#print " $list[$humid_to_loc] \n";

my $lowest_loc=0;

for my $i (0..$#seeds) {
    my $seed = $seeds[$i];

    my $idx = $seed_to_soil + 1;
    while ( $list[$idx] !~ /(\s|\n)/ ) { 
        my @ranges = split(" ",$list[$idx]);
        if ( $seed < $range[1]+$range[2] ) {
            $lowest_loc = $ranges[1];
            last;
        }
        $idx++;
    }
}
