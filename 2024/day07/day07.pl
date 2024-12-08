#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my @result;
my @nums;

while (my $line = <$fh>) {
    chomp $line;
	if ($line =~ /^(\d+):\s*(\d+(?: \d+)*)$/) {
		push @result, $1;
		my @list = split /\s+/, $2;
		push @nums, \@list;
	}
}

close $fh;

sub generate_perms {
    my ($prefix, $length) = @_;

    my @permutations;

    if ($length == 0) {
        push @permutations, $prefix;
    } else {
        push @permutations, generate_perms($prefix . '*', $length - 1);
        push @permutations, generate_perms($prefix . '+', $length - 1);
    }

    return @permutations;
}

sub generate_perms2 {
    my ($prefix, $length) = @_;

    my @permutations;

    if ($length == 0) {
        push @permutations, $prefix;
    } else {
        push @permutations, generate_perms2($prefix . '*', $length - 1);
        push @permutations, generate_perms2($prefix . '+', $length - 1);
        push @permutations, generate_perms2($prefix . '|', $length - 1);
    }

    return @permutations;
}

sub part1 {
	my $sum=0;
	for my $i (0 .. $#nums) {
		my @operators = generate_perms("", $#{$nums[$i]});
		for my $j (0 .. $#operators) {
			my $expression = $nums[$i][0];
			my $res = $nums[$i][0];
			my @ops = split('', $operators[$j]);
			for my $k ( 0 .. $#ops) {
				$expression .= " $ops[$k] $nums[$i][$k + 1]";
				if ($ops[$k] eq '+') {
					$res = $res + $nums[$i][$k+1];
				} else {
					$res = $res * $nums[$i][$k+1];
				}
			}
			# # my $res = eval $expression;
			# if ($@) {
			# 	print "Error evaluating expression: $@\n";
			# 	last;
			# }
			# print($expression, " = ", $res, "\n");
			if ($res == $result[$i]) {
				$sum = $sum + $res;
				last;
			}
		}
	}


	print("Part 1: ", $sum, "\n");
}

#part1();

sub part2 {
	my $sum=0;
	for my $i (0 .. $#nums) {
		my @operators = generate_perms2("", $#{$nums[$i]});
		for my $j (0 .. $#operators) {
			my $expression = $nums[$i][0];
			my $res = $nums[$i][0];
			my @ops = split('', $operators[$j]);
			my $k = 0;
			while($k <= $#ops) {
				$expression .= " $ops[$k] $nums[$i][$k + 1]";
				if ($ops[$k] eq '+') {
					$res = $res + $nums[$i][$k+1];
				} elsif ($ops[$k] eq '*') {
					$res = $res * $nums[$i][$k+1];
				} else {
					my $n = $nums[$i][$k+1];
					while($n > 0) {
						$n = int($n/10);
						$res = $res*10;
					}
					$res = $res + $nums[$i][$k+1];
				}
				$k++;
			}
			#print($expression, " = ", $res, "\n");
			if ($res == $result[$i]) {
				$sum = $sum + $res;
				last;
			}
		}
	}


	print("Part 2: ", $sum, "\n");
}

part2();
