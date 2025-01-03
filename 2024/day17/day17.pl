#!/opt/local/bin/perl
use strict;
use warnings;


my $A = 0;
my $B = 0;
my $C = 0;
my $program = "2,4,1,3,7,5,4,0,1,3,0,3,5,5,3,0,";

my @pg = split /,/, $program;

sub get_operand {
    my ($operand) = @_;
    if ($operand == 4) {
        $operand = $A;
    } elsif ($operand == 5) {
        $operand = $B;
    } elsif ($operand == 6) {
        $operand = $C;
    }

    return $operand;
}

sub do_stuff {
    my ($opcode, $operand) = @_;
    if($opcode == 0) {
        $A = int($A/(2**$operand));
    } elsif($opcode == 1) {
        $B = $B^$operand;
    } elsif($opcode == 2) {
        $B = $operand%8;
    } elsif($opcode == 4) {
        $B = $B^$C;
    } elsif($opcode == 5) {
        my $temp = $operand%8;
        return "$temp,";
    } elsif($opcode == 6) {
        $B = int($A/(2**$operand));
    } else {
        $C = int($A/(2**$operand));
    }
    return "";
}
sub part1 {
	my $i = 0;
    my $output = "";
	while($i < $#pg) {
        if($pg[$i] == 3 && $A != 0) {
            $i = get_operand($pg[$i+1]);
            next;
        }
        $output .= do_stuff($pg[$i], get_operand($pg[$i+1]));
        $i+=2;
	}
    print("Register A: $A \n");
    print("Register B: $B \n");
    print("Register C: $C \n");
    print("output: $output \n");
}

sub part2 {
    my $output = "";
    my $k = 107674113259984 + 107674116852704/64;
    while($output ne $program) {
        $output = "";
        my $i = 0;
        $A = $k;
        $B = 0;
        $C = 0;
        print("A: $A\n");
        while($i < $#pg) {
            if($pg[$i] == 3 && $A != 0) {
                $i = get_operand($pg[$i+1]);
                next;
            }
            $output .= do_stuff($pg[$i], get_operand($pg[$i+1]));
            $i+=2;
        }
        print("output: $output \n");
        $k+=8;
	}
}



part2();
