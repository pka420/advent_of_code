#!/bin/perl
#
use strict;

my $file_path = @ARGV[0];
open my $file_handle, '<', $file_path or die "Could not open '$file_path': $!";


my $min = 7;
my $max = 27;
if ( $file_path =~ /input/ ) {
    $min = 200000000000000;
    $max = 400000000000000;
}

my @list1;
my @list2;
while (my $line = <$file_handle>) {
    chomp $line;
    my @row = split /@/, $line;
    push @list1, $row[0];
    push @list2, $row[1];
}



close $file_handle;

