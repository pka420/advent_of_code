#!/bin/perl
use POSIX;

# testing:
# my @time=(7,15,30);
# my @distance=(9,40,200);
# actual input:
my @time=(56,97,78,75);
my @distance=(546,1927,1131,1139);

$idx=0;
$prod=1;
my @count=(0,0,0);
while ($idx <= $#time) {
    my $half = floor($time[$idx]/2);
    # print "half of $time[$idx] is $half \n";
    for ($i=$half ; $i >= 1; $i--) {
        if ($i*($time[$idx]-$i) > $distance[$idx]) {
            $count[$idx]++;
        }
        else {
           last;
        }
    }
    $count[$idx]=2*$count[$idx];
    if ($time[$idx] % 2 == 0) {
        $count[$idx]--;
    }
    # print " found $count[$idx] cases for time $time[$idx] \n";
    $prod *= $count[$idx];
    $idx++;
}
print "total cases $prod \n";
#
# PART 2:
#
my $time=56977875;
my $distance=546192711311139;
my $count=0;
my $half = floor($time/2);
for ($i=$half ; $i >= 1; $i--) {
    if ($i*($time-$i) > $distance) {
        $count++;
    }
    else {
       last;
    }
}
$count=2*$count;
if ($time % 2 == 0) {
    $count--;
}

print " found $count cases for time $time \n";
