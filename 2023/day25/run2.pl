#!/bin/perl
use Graph;


my $file_path = @ARGV[0];
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";

my $graph = Graph->new;

my @list;
while (my $line = <$file_handle>) {
    chomp $line;
    my @row = split /:/, $line;
    my $col = split /,/, $row[1];
    for my $i (0 .. $col) {
        $graph->add_edge($row[0], $row[1]);
    }
    push @list, $line;
}

my ($cut1, $cut2) = $graph->mincut('fjn', 'mzb');

print "len of cut1: $cut1\n";
print "len of cut2: $cut2\n";

close $file_handle;

