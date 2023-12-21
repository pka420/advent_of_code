#!/opt/local/bin/perl
use Text::CSV_XS;

$red_MAX = 12;
$green_MAX = 13;
$blue_MAX = 14;

my $csv = Text::CSV_XS->new({ sep_char => ';' });
my $file = 'input.csv';  
open my $fh, '<', $file or die "Could not open '$file': $!";

$sum=0;
while (my $row = $csv->getline($fh)) {
    $game=0; $result=1;
    @$row[0] =~ /(\d+)/;
    $game = $1;
    print "Game: $game \n";

    my @columns = @$row;
    $max_red=0;
    $max_green=0;
    $max_blue=0;
    for my $column (@columns) {
        $red=0;
        $green=0;
        $blue=0;
        while ($column =~ /(\d+)red/g) {
            $red += $1;
        }
        while ($column =~ /(\d+)green/g) {
            $green += $1;
        }
        while ($column =~ /(\d+)blue/g) {
            $blue += $1;
        }  
        if ($red > $max_red) {
            $max_red = $red;
        }
        if ($green > $max_green) {
            $max_green = $green;
        }
        if ($blue > $max_blue) {
            $max_blue = $blue;
        }
    }
    print "Max red: $max_red \n";    
    print "Max green: $max_green \n";
    print "Max blue: $max_blue \n";
    $result = $max_red*$max_green*$max_blue;
    $sum += $result;

#     for my $column (@columns) {
#         $red=0;
#         $green=0;
#         $blue=0;
#         while ($column =~ /(\d+)red/g) {
#             $red += $1;
#         }
#         while ($column =~ /(\d+)green/g) {
#             $green += $1;
#         }
#         while ($column =~ /(\d+)blue/g) {
#             $blue += $1;
#         }
#         # print "red: $red, green: $green, blue: $blue \n";
#         if ($red > $red_MAX || $green > $green_MAX || $blue > $blue_MAX) {
#             $result = 0;
#             last;
#         }
#     }
#     if ($result == 1) {
#         $sum += $game;
#     }
}
print "Sum: $sum\n";
close $fh;
exit 0;
