#!/opt/local/bin/perl
#
my $file_path = 'input.txt';
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";

my @list;
while (my $line = <$file_handle>) {
    chomp $line;  
    push @list, $line;
}

close $file_handle;

sub get_sum {
    my ($prev_line, $curr, $next_line) = @_;
    my $sum=0;
    while ( $curr =~ /(\d+)/g ) {
        $str1 = "";
        $num = $1;
        $pos = index($curr, $num);
        $len = length($num);
        print "found number $num at position $pos, with length $len\n";
    
        $str1 .= substr($curr, $pos-1, 1);
        $str1 .= substr($next_line, $pos-1, $len+2);
        $str1 .= substr($prev_line, $pos-1, $len+2);
        $str1 .= substr($curr, $pos + $len, 1);
    
        print "str1: $str1 \n";
        $str1 =~ s/\.//g;
        $str1 =~ s/\d+//g;
        print "str1: $str1 \n";

        if ( length($str1) > 0 ) {
            print "found adjacent for $num\n";
            $sum += $num;
        }
    }
    return $sum;
}

$sum = 0;
for my $i (0..$#list) {
    my $curr_line = $list[$i];
    if ($i == 0) {
        $prev_line = $list[$i+1];
    }
    else {
        $prev_line = $list[$i-1];
    }
    if ( $i == $#list ) {
        $next_line = $list[$i-1];
    }
    else {
        $next_line = $list[$i+1];
    }

    $sum += get_sum($prev_line, $curr_line, $next_line);
}
print "$sum\n";
