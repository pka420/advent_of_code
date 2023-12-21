#!/opt/local/bin/perl
#
$column = "12green,11red,23red,4blue";
$red=0;

while ($column =~ /(\d+)red/g) {
    $red += $1;
}
print $red
