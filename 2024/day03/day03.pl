#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'part1.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my $text = do { local $/; <$fh> };

my $pattern =  'mul\((\d+),(\d+)\)';
my $do_pattern =  'do\(\)';
my $dont_pattern =  "don\'t\(\)";


my $sum = 0;

while ($text =~ /$pattern/g) {
    my $match = $&;
		my $num1 = $1;
		my $num2 = $2;
		$sum = $sum + $num1*$num2;
}
print("Part 1: ", $sum, "\n");

$sum = 0;
my $flag=1;

while ($text =~ /($pattern|$do_pattern|$dont_pattern)/g) {
    my $match = $1;
		if ($match =~ $do_pattern) {
			#print("found do", "\n");
			$flag=1;
		}
		elsif($match =~ $dont_pattern) {
			#print("found don't", "\n");
			$flag=0;
		}
		elsif($match =~ $pattern && $flag == 1) {
			my ($num1, $num2) = ($1, $2);
			$sum = $sum + $num1*$num2;
		}
}
print("Part 2: ", $sum, "\n");


close($fh);
