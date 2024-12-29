#!/opt/local/bin/perl
use strict;
use warnings;

my $file = 'input.txt';
open my $fh, '<', $file or die "Could not open '$file': $!";

my $count = 0;
my @unsafe_list;

while (my $line = <$fh>) {
	chomp $line;
	my @list = split ' ', $line;
	my $flag = 1;
	my $diff = 0;
	if($list[1] > $list[0]) {
		for my $i (0 .. $#list-1) {
			$diff = $list[$i+1]-$list[$i];
			if ($list[$i+1] < $list[$i] || $diff > 3 || $diff < 1) {
				$flag=0;
				last;
			}
		}
	} elsif ($list[1] < $list[0]) {
		for my $i (0 .. $#list-1) {
			$diff = $list[$i]-$list[$i+1];
			if ($list[$i+1] > $list[$i] || $diff > 3 || $diff < 1) {
				$flag=0;
				last;
			}
		}
	} else {
		$flag=0;
	}

	if ($flag == 1) {
		$count++;
	} else {
        push @unsafe_list, \@list;
    }
}

print("Part 1 : ", $count);
print("\n");

close $fh;

for my $k (0 .. $#unsafe_list) {
    my $list_ref = $unsafe_list[$k];  
	my @list = @$list_ref;
	my $flag = 1;
	my $diff = 0;
	for my $col_idx (0 .. $#list) {
        my $removed = splice(@list, $col_idx, 1);
        if($list[1] > $list[0]) { 
	        $flag = 1;
            for my $i (0 .. $#list-1) {
                $diff = $list[$i+1]-$list[$i];
                if ($list[$i+1] < $list[$i] || $diff > 3 || $diff < 1) {
                    $flag=0;
                    last;
                }
            }
            if($flag == 1) {
                $count++;
                last;
            }
        } elsif ($list[1] < $list[0]) {
            $flag = 1;
            for my $i (0 .. $#list-1) {
                $diff = $list[$i]-$list[$i+1];
                if ($list[$i+1] > $list[$i] || $diff > 3 || $diff < 1) {
                    $flag=0;
                    last;
                }
            }
            if($flag == 1) {
                $count++;
                last;
            }
		}
        splice(@list, $col_idx, 0, $removed);
	} 
}

print("Part 2 : $count \n");


