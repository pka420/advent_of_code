#!/opt/local/bin/perl
use strict;
use warnings;

sub is_integer {
    my ($num) = @_;
    return $num =~ /^[+-]?\d+$/;
}

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my ($a0, $a1, $b0, $b1, $p0, $p1);
my $tokens = 0;

while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;

    print "$line \n";
    if ($line =~ /X\+(\d+), Y\+(\d+)/) {
        ($a0, $a1) = ($1, $2);
    }
    my $line2 = <$fh>;
    chomp $line2;
    print "$line2 \n";
    if ($line2 =~ /X\+(\d+), Y\+(\d+)/) {
        ($b0, $b1) = ($1, $2);
    }
    $line2 = <$fh>;
    chomp $line2;
    if ($line2 =~ /X\=(\d+), Y\=(\d+)/) {
        ($p0, $p1) = ($1, $2);
    }

    $p0+=10000000000000;
    $p1+=10000000000000;
    print("Prize: X=$p0, Y=$p1\n");

    my $times_b = ($p1 * $a0 - $p0 * $a1)/($b1 * $a0 - $b0 * $a1);
    my $times_a = ($p0 - $b0 * $times_b) / $a0;

    # if(0 <= $times_a <= 100 && 0 <= $times_b <= 100 && is_integer($times_b) && is_integer($times_a) ) {
    #     $tokens = $tokens + $times_a*3 + $times_b;
    #     print "Solution:\n";
    #     print "a = ", $times_a, "\n";
    #     print "b = ", $times_b, "\n";
    # }
    if(0 <= $times_a && 0 <= $times_b && is_integer($times_b) && is_integer($times_a) ) {
        $tokens = $tokens + $times_a*3 + $times_b;
        print "Solution:\n";
        print "a = ", $times_a, "\n";
        print "b = ", $times_b, "\n";
    }
}

print"tokens: $tokens \n";

close $fh;
