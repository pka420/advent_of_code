#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @list;
my @updates;
my @incorrect_updates;

while (my $line = <$fh>) {
    chomp $line;
    if ($line =~ /^\s*$/) {
        last;
    }
    push @list, $line;
}

while(my $line = <$fh>) {
    chomp $line;
    push @updates, $line;
}

close $fh;

my $sum = 0;
for my $i (0 .. $#updates) {
    my @line = split ',', $updates[$i];
    my $flag=1;
    for my $j (0 .. $#line) {
        for my $k ($j+1 .. $#line) {
            my $incorrect_rule = $line[$k]."|".$line[$j];
		    my @indexes = grep { $list[$_] eq $incorrect_rule } 0..$#list;
            if ($#indexes > -1) {
                $flag=0;
                last;
            }
        }
        if ($flag == 0) {
            last;
        }
    }
    if ($flag == 1) {
        $sum += $line[$#line/2];
    }
    else {
        push @incorrect_updates, $updates[$i];
    }
}

print("Part 1: $sum\n");
$sum = 0;

for my $i (0 .. $#incorrect_updates) {
    my @line = split ',', $incorrect_updates[$i];
    my $flag=1;
    for my $j (0 .. $#line) {
        for my $k ($j+1 .. $#line) {
            my $incorrect_rule = $line[$k]."|".$line[$j];
		    my @indexes = grep { $list[$_] eq $incorrect_rule } 0..$#list;
            if ($#indexes > -1) {
                my $temp = $line[$k];
                $line[$k] = $line[$j];
                $line[$j] = $temp;
            }
        }
    }
    $sum += $line[$#line/2];
}


print("Part 2: $sum\n");
