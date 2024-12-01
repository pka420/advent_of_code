#!/bin/perl


my $file_path = @ARGV[0];
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";


# if ( $file_path =~ /input/ ) {
# }

my @list;
my @leftCell;
my %uniqComp;
while (my $line = <$file_handle>) {
    chomp $line;
    my @row = split /:/, $line;
    while ( $line =~ /(\w+)/g ) {
        $uniqComp{$1} = 1;
    }
    push @leftCell, $row[0];
    push @list, $line;
}
close $file_handle;



sub get_nodes {
    foreach my $i (0 .. $#leftCell) {
        my $line = $list[$i];
        print "$leftCell[$i] -- {$line}\n";
    }
}

# get_nodes();

my @solution;
my @solution1;
sub solve_part1 {
    my $line = $list[0];
    my @row = split /,/, $line;
    foreach my $j (0 .. $#row) {
        my $cell = $row[$j];
        my $edge = "$leftCell[0] -- $cell";
        push @solution, $edge;
    }
    # print "Graph G {\n";
    foreach my $i (1 .. $#leftCell) {
        my $line = $list[$i];
        my @row = split /,/, $line;
        foreach my $j (0 .. $#row) {
            my $cell = $row[$j];
            my $edge = "$leftCell[$i] -- $cell";
            if (grep { $_ eq $cell } @solution || grep { $_ eq $leftCell[$i] } @solution) {
                push @solution, $edge;
            }
            else {
                push @solution1, $edge;
            }
        }
    }
    # print "}";
}

my %uniqComp1;
my %uniqComp2;
sub solve_part {
    my $line = $list[0];
    my @row = split /,/, $line;
    for my $j (0 .. $#row) {
        print "adding $row[$j] to uniqComp1\n";
        $uniqComp1{$row[$j]} = 1;
    }

    foreach $i (1 .. $#list) {
        my $line = $list[$i];
        my @row = split /,/, $line;
        print "$line\n";
        for my $j (0 .. $#row) {
            my $added = 0;
            my $cell = $row[$j];
            if (exists $uniqComp1{$cell} && !exists $uniqComp2{$cell}) {
                for my $k (0 .. $#row) {
                    if (!exists $uniqComp1{$row[$k]} ) {
                        print "adding $row[$k] to uniqComp1\n";
                        $uniqComp1{$row[$k]} = 1;
                    }
                }
                $added=1;
                last;
            }
            else {
                for my $k (0 .. $#row) {
                    if (!exists $uniqComp2{$row[$k]} ) {
                        print "adding $row[$k] to uniqComp2\n";
                        $uniqComp2{$row[$k]} = 1;
                    }
                }
                $added=1;
                last;
            }
            if ($added) {
                last;
            }
        }
    }
}

# solve_part1();
solve_part();

my $len1 = scalar(keys %uniqComp1);
my $len2 = scalar(keys %uniqComp2);
print "length of solution: $len1\n";
print "length of solution1: $len2\n";

# foreach my $line (@solution) {
#     print "$line\n";
# }
