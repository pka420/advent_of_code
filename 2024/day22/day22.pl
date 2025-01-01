#!/opt/local/bin/perl
use strict;
use warnings;
use POSIX qw(ceil);

my @list;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

while (my $line = <$fh>) {
    chomp $line;
	push @list, $line;
}

close $fh;
#@list = (1, 2, 3, 2024);

sub bitwise_xor {
    my ($a, $b) = @_;
    return $a ^ $b;
}

sub next_secret_num {
    my ($sec_num) = @_;

    $sec_num = bitwise_xor($sec_num, $sec_num*64);
    $sec_num = $sec_num%16777216;
    $sec_num = bitwise_xor(int($sec_num/32), $sec_num);
    $sec_num = $sec_num%16777216;
    $sec_num = bitwise_xor($sec_num, $sec_num*2048);
    $sec_num = $sec_num%16777216;
    return $sec_num;
}

sub part1 {
    my $sum=0;
    my $secret_number;
    for my $j ( 0 .. $#list) {
        $secret_number = $list[$j];
        for my $i ( 0 .. 2000-1) {
            $secret_number = next_secret_num($secret_number);
        }
        $sum = $sum + $secret_number;
    }
    print("sum : ", $sum, "\n");
}

#part1();

sub part2 {
    my $secret_number;

    my @patterns; 
    my %all_patterns;

    for my $j ( 0 .. $#list) {
        my @seq;
        my @pr;
        my %ptrn;
        my $k = 0;
        $secret_number = $list[$j];
        $secret_number = next_secret_num($secret_number);
        push @pr, $secret_number%10;
        for my $i ( 1 .. 2000) {
            $secret_number = next_secret_num($secret_number);
            push @pr, $secret_number%10;
            push @seq, $pr[$i] - $pr[$i-1];
        }
        while($k < 1996) {
            if (! exists $ptrn{"$seq[$k],$seq[$k+1],$seq[$k+2],$seq[$k+3]"}) {
                $ptrn{"$seq[$k],$seq[$k+1],$seq[$k+2],$seq[$k+3]"} = $pr[$k+4];
            }
            $all_patterns{"$seq[$k],$seq[$k+1],$seq[$k+2],$seq[$k+3]"} = 0;
            $k++;
        }
        push @patterns, \%ptrn;
    }
     
    my $max_sum = 0;

    my $size = keys %all_patterns;
    print("len of all patterns: $size \n");


    for my $ptrn (keys %all_patterns) {
        my $sum = 0;
        for my $i ( 0 .. $#list) {
            if ( exists $patterns[$i]{$ptrn}) {
                $sum = $sum + $patterns[$i]{$ptrn};
            }
        }
        if ($sum > $max_sum) {
            $max_sum = $sum;
        }
    }
    print("max sum : ", $max_sum, "\n");
}

part2();
