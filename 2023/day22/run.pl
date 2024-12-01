#!/bin/perl

use strict;

my $file_path = @ARGV[0];
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";

my $steps=5;
if ($file_path =~ /input/) {
        $steps=63;
}

my @list1;
my @list2;
while (my $line = <$file_handle>) {
    chomp $line;
    my @row = split /~/, $line;
    my @col1 = split /,/, $row[0];
    my @col2 = split /,/, $row[1];
    push @list1, \@col1;
    push @list2, \@col2;
}

close $file_handle;

print "\n list1 \n";
foreach my $row (@list1) {
    foreach my $elem (@$row) {
        print "$elem,";
    }
    print "\n";
}
print "\n list2: \n";
foreach my $row (@list2) {
    foreach my $elem (@$row) {
        print "$elem,";
    }
    print "\n";
}

