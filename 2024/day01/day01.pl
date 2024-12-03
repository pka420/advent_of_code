#!/opt/local/bin/perl
use Text::CSV_XS;

my $csv = Text::CSV_XS->new({ sep_char => ',' });
my $file = 'input.csv';
open my $fh, '<', $file or die "Could not open '$file': $!";

my @list1;
my @list2;

while (my $line = <$fh>) {
	chomp $line;
	my ($val1, $val2) = split /,/, $line;

	push @list1, $val1;
	push @list2, $val2;
}

@listA = sort { $a <=> $b } @list1;
@listB = sort { $a <=> $b } @list2;

close $fh;

my @distances;
my $sum = 0;
my $distance;


for my $i (0 .. $#listA) {
	$distance = abs($listA[$i] - $listB[$i]);
	$sum = $sum + $distance;
	push @distances, $distance;
}

print("Part 1 : ", $sum);
print("\n");

$sum = 0;
for my $i (0 .. $#listA) {
	my $count = 0;
	$count++ for grep { $_ == $listA[$i] } @listB;
	$sum = $sum + $count*$listA[$i];
}
print("Part 2 : ", $sum);
print("\n");

exit 0;

