#!/opt/local/bin/perl
use strict;
use warnings;

my %keys;
my %locks;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

my $j=0;
while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;
    if ( $line =~ /^#####$/ ) {
        my @lock = ( 0, 0, 0, 0, 0 );
        $j = 0;
        while ($j <= 4) {
            my $line = <$fh>;
            chomp $line;
            for my $i ( 0 .. 4) {
                if (substr($line, $i, 1) eq '#') {
                    $lock[$i] += 1;
                }
            }
            $j++;
        }
        my $line = <$fh>;
        $locks{join(",", @lock)} = 0;
    } elsif ( $line =~ /^\.\.\.\.\.$/) {
        my @key = ( 0, 0, 0, 0, 0 );
        $j=0;
        while ($j<=4) {
            my $line = <$fh>;
            chomp $line;
            for my $i ( 0 .. 4) {
                if (substr($line, $i, 1) eq '#') {
                    $key[$i] += 1;
                }
            }
            $j++;
        }
        my $line = <$fh>;
        $keys{join(",", @key)} = 0;
    }
}
close $fh;

# print("locks: \n");
# foreach my $lock (keys %locks) {
#     print( $lock, "\n");
# }
# print("keys: \n");
# foreach my $key (keys %keys) {
#     print( $key, "\n");
# }
my $len = scalar keys %locks;
print("num of locks: $len \n");
$len = scalar keys %keys;
print("num of keys: $len \n");

my $opened_locks = 0;
foreach my $key ( keys %keys) {
    foreach my $lock ( keys %locks) {
        my $opened = 1;
        my @l = split(',', $lock);
        my @k = split(',', $key);
        for my $i ( 0 .. 4) {
            if ($k[$i] + $l[$i] > 5) {
                $opened = 0;
                last;
            }
        }
        $opened_locks += 1 if $opened == 1;
    }
}
print("locks opened: $opened_locks \n");


