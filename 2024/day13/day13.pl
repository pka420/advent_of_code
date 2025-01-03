#!/opt/local/bin/perl
use strict;
use warnings;
use Math::MatrixReal;

sub is_integer {
    my ($num) = @_;
    return $num =~ /^[+-]?\d+$/;
}

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my ($x1, $x2, $y1, $y2);
my $tokens;

while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;

        print "$line \n";
        if ($line =~ /X\+(\d+), Y\+(\d+)/) {
            ($x1, $y1) = ($1, $2);
        }
        my $line2 = <$fh>;
        chomp $line2;
        print "$line2 \n";
        if ($line2 =~ /X\+(\d+), Y\+(\d+)/) {
            ($x2, $y2) = ($1, $2);
        }
        my $matrix = Math::MatrixReal->new_from_rows([
            [$x1, $x2],
            [$y1, $y2],
        ]);
        $line2 = <$fh>;
        chomp $line2;
        print "$line2 \n";
        if ($line2 =~ /X\=(\d+), Y\=(\d+)/) {
            ($x1, $y1) = ($1, $2);
        }

        my $vector = Math::MatrixReal->new_from_rows([
            [$x1],
            [$y1],
        ]);

        my ($inverse, $error) = $matrix->inverse();
        if ( defined $error) {
            print("matrix inverse failed");
            next;
        } else {
            my $solution = $inverse*$vector;
            $x1 = $solution->element(1,1);
            $y1 = $solution->element(2,1);

            if(!is_integer($x1) || !is_integer($y1) ) {
                next;
            }

            $tokens = $tokens + $x1*3 + $y1;

            print "Solution:\n";
            print "a = ", $x1, "\n";
            print "b = ", $y1, "\n";
        }
}

print"tokens: $tokens \n";
