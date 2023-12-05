#!/opt/local/bin/perl
use Text::CSV_XS;


my $csv = Text::CSV_XS->new({ sep_char => '|' });
my $file = 'test.csv';  
open my $fh, '<', $file or die "Could not open '$file': $!";


$sum=0;
$n=6;
@won_scratchcards = (1)x$n;
print "won_scratchcards: @won_scratchcards\n";
$idx=1;
while (my $row = $csv->getline($fh)) {
    my $card = $row->[0];
    $card =~ s/[a-zA-Z]//g;
    print "card: $card\n";

    my @winnig_chars = split /,/, $row->[1];
    my @my_chars = split /,/, $row->[2];

    $win_count=-1;
    for my $i (0..$#my_chars) {
        my $value = $my_chars[$i];
        if ( grep( /^$value$/, @winnig_chars ) ) {
            $win_count++;
        }
    }
    if ( $win_count > 0 ) {
        $len = $win_count++;
        splice(@won_scratchcards, $idx, $idx+$win_count, ($won_scratchcards[$idx])*$win_count+1 );
    }
    print "won_scratchcards: @won_scratchcards\n";
    $idx++;
}
for my $i (0..$#won_scratchcards) {
    $sum += $won_scratchcards[$i];
}
print "sum: $sum\n";
