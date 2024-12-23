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
    #print("secret number: ", $sec_num, "\n");
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
sub get_substr {
    my ($string, $start_index) = @_;
    my $substring = "";  # Initialize the result substring
    my $digit_count = 0; # Counter for digits

    # Iterate through the string from the start index
    for my $i ($start_index .. length($string) - 1) {
        my $char = substr($string, $i, 1);  # Get the character at position $i
        $substring .= $char;               # Append the character to the substring

        # Increment digit count if the character is a digit
        $digit_count++ if $char =~ /\d/;

        # Stop once we've hit at least 3 digits
        last if $digit_count >= 3;
    }

    return $substring;
}

sub part2 {
    my $secret_number;

    my @sequence;
    my @prices;

    for my $j ( 0 .. $#list) {
        my @seq;
        my @pr;
        $secret_number = $list[$j];
        $secret_number = next_secret_num($secret_number);
        push @pr, $secret_number%10;
        push @seq, 0;
        for my $i ( 1 .. 2000-1) {
            $secret_number = next_secret_num($secret_number);
            push @pr, $secret_number%10;
            push @seq, $pr[$i] - $pr[$i-1];
        }
        push @sequence, \@seq;
        push @prices, \@pr;
    }

    my $idx;
    my $p = 1;
    my $max_sum = 0;
    while( $p+3 < 2000) {
        my $sum = 0;
        my @pattern;
        for my $k ($p .. $p+3) {
            push @pattern,$sequence[0][$k];
        }
        #print("finding pattern: ", join("", @pattern), "\n");
        for my $i ( 1 .. $#sequence) {
            my $j = 1;
            $idx = -1;
            while ($j < 1996) {
                if ($sequence[$i][$j] == $pattern[0] &&
                    $sequence[$i][$j+1] == $pattern[1] &&
                    $sequence[$i][$j+2] == $pattern[2] &&
                    $sequence[$i][$j+3] == $pattern[3]) {
                    $idx = $j+3;
                    last;
                }
                $j += 1;
            }
            if ($idx != -1) {
                $sum += $prices[$i][$idx];
            }
        }
        if ($sum > $max_sum) {
            $max_sum = $sum;
        }
        #last if ($pattern[0] == -2 && $pattern[1] == 1 && $pattern[2] == -1 && $pattern[3] == 3);
        $p += 1;
    }
    print("max sum : ", $max_sum, "\n");
}

part2();
