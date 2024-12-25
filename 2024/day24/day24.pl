#!/opt/local/bin/perl
use strict;
use warnings;

my $filename = 'sample.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my %inputs;
my %gates;

while (my $line = <$fh>) {
    chomp $line;
	if ( $line =~ /^(\w+):\s*(\d)$/ ) {
        $inputs{$1} = $2;
	} else {
        $gates{$line} = 0;
    }
}

close $fh;

# foreach my $key ( keys %inputs ) {
#     print("$key : $inputs{$key} \n");
# }

while (grep { $_ != 1 } values %gates) {
    foreach my $key ( keys %gates ) {
        if ($key =~ /^(\w+)\s+(\w+)\s+(\w+)\s+->\s+(\w+)$/) {
            my ($input1, $gate, $input2, $output) = ($1, $2, $3, $4);
            if (exists $inputs{$input1} && exists $inputs{$input2}) {
                if ($gate eq 'OR') {
                    $inputs{$output} = $inputs{$input1} || $inputs{$input2};
                } elsif ($gate eq 'AND') {
                    $inputs{$output} = $inputs{$input1} && $inputs{$input2};
                } elsif ($gate eq 'XOR') {
                    $inputs{$output} = $inputs{$input1} ^ !!$inputs{$input2};
                    print(" $key : $inputs{$output} \n");
                }
                $gates{$key} = 1; # mark as visited.
            }
        }
    }
}
my $bool = "";
my $num = 0;
my $i=0;
foreach my $key ( sort { $b cmp $a } keys %inputs ) {
    if ( $key =~ /^z(\w+)$/) {
        $bool .= $inputs{$key};
        $num = $num + $inputs{$key}*(2^$i);
        print("$key : $inputs{$key} \n");
        $i++;
    }
}

print("bool: $bool \n");
print("num: $num \n");



