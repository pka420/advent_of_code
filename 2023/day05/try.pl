#!/opt/local/bin/perl
use strict;
use warnings;

my $str="23 23 45";

my @arr=split(" ",$str);

print "@arr \n";

$str=" ";

if ( $str =~ /(\s|\n)/ ) {
    print "yes \n";
}
