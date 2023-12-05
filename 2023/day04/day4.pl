#!/opt/local/bin/perl
use Text::CSV_XS;


my $csv = Text::CSV_XS->new({ sep_char => '|' });
my $file = 'input2.csv';  
open my $fh, '<', $file or die "Could not open '$file': $!";




$sum=0;
$n=199;
@won_scratchcards = (1)x$n;
# print "won_scratchcards: @won_scratchcards\n";

$idx=0;
while (my $row = $csv->getline($fh)) {
    my $card = $row->[0];
    $card =~ s/[a-zA-Z]//g;
    # print "card: $card\n";
#
    my @winnig_chars = split /,/, $row->[1];
    my @my_chars = split /,/, $row->[2];

    $win_count=0;
    for my $i (0..$#my_chars) {
        my $value = $my_chars[$i];
        if ( grep( /^$value$/, @winnig_chars ) ) {
            $win_count++;
        }
    }
    # print "win_count: $win_count\n";
    if ( $win_count > 0 ) {
        for my $i (1..$win_count) {
            $won_scratchcards[$idx+$i] = $won_scratchcards[$idx+$i]+$won_scratchcards[$idx];
        }
    }
    # print "won_scratchcards: @won_scratchcards\n";
    $idx++;
}
for my $i (0..$#won_scratchcards) {
    $sum += $won_scratchcards[$i];
}
print "sum: $sum\n";
