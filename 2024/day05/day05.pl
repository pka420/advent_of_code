#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample1.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @list1; # n*2 list
my @list2; # n*2 list

while (my $line = <$fh>) {
    chomp $line;
    my ($num1, $num2) = split /\|/, $line;
    push @list1, $num1;
    push @list2, $num2;
}

close $fh;

$filename = 'sample2.txt';
open($fh, '<', $filename) or die "Could not open file '$filename': $!";

my @updates; # 2d list

while (my $line = <$fh>) {
    chomp $line;
    my @nums = split /,/, $line;
    push @updates, \@nums;
}

close $fh;

for my $i (0 .. $#updates) {
	my @line = @{$updates[$i]};
	my $j = 0;
	while ($j < $#line) {
		print("finding ", $line[$j], " in list1", "\n");
		my @indexes = grep { $list1[$_] == $line[$j] } 0..$#list1;
		for my $k (0..$#indexes) {

		}
		print("\n");
		$j++;
	}
}
