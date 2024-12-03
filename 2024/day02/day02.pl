#!/opt/local/bin/perl
use Text::CSV_XS;

my $file = 'input.txt';
open my $fh, '<', $file or die "Could not open '$file': $!";

my $count = 0;

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
	}
}

print("Part 1 : ", $count);
print("\n");

close $fh;
open $fh, '<', $file or die "Could not open '$file': $!";

$count = 0;
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
				splice(@list, $i, 1);
				$flag=0;
				last;
			}
		}
	} elsif ($list[1] < $list[0]) {
		for my $i (0 .. $#list-1) {
			$diff = $list[$i]-$list[$i+1];
			if ($list[$i+1] > $list[$i] || $diff > 3 || $diff < 1) {
				splice(@list, $i, 1);
				$flag=0;
				last;
			}
		}
	} else {
		$flag=0;
		splice(@list, 0, 1);
	}

	if ($flag == 1) {
		$count++;
	}
	else {
		push @unsafe_list, \@list;
	}
}

close $fh;

for my $k (0 .. $#unsafe_list) {
	my $list = $unsafe_list[$k];
	for my $j (0 .. $#list-1) {
		print($list[$j], " ");
	}
	print("\n");
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
	}
}

print("Part 2 : ", $count);
print("\n");

exit 0;


