#!/opt/local/bin/perl
use strict;
use warnings;
use Memoize;

my $filename = 'sample.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @patterns;
my @designs;

my $line = <$fh>;
chomp $line;

@patterns = split /, /, $line;

$line = <$fh>;
while($line = <$fh>) {
    chomp $line;
    push @designs, $line;
}
close $fh;


memoize("design_possible");
sub design_possible {
    my ($design) = @_;
    my $len = length($design);

    return 1 if $len == 0;

    for my $i ( 1 .. $len) {
        my $str = substr $design, 0, $i;
        my @matches = grep { $_ eq $str } @patterns;
        if ( @matches && design_possible(substr($design, $i)) ) {
            return 1;
        }
    }
    return 0;
}

memoize("count_possiblities");
sub count_possiblities {
    my ($design) = @_;
    my $len = length($design);

    return 1 if $len == 0;
    my $count = 0;

    for my $i ( 1 .. $len) {
        my $str = substr $design, 0, $i;
        my @matches = grep { $_ eq $str } @patterns;
        if ( @matches ) {
            $count += count_possiblities(substr($design, $i));
        }
    }
    return $count;
}

my $sum = 0;
for my $i (0 .. $#designs) {
    if (design_possible($designs[$i]) == 1) {
        $sum += 1;
    }
}

print("Part1: $sum \n");

$sum = 0;
for my $i (0 .. $#designs) {
    $sum += count_possiblities($designs[$i]);
}
print("Part2: $sum \n");
