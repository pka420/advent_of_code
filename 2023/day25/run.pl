#!/bin/perl
use GraphViz2;
use Try::Tiny;


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
    push @list, $row[1];
}
close $file_handle;



# foreach my $line (@list) {
#     print "$line\n";
# }

sub solve_part1 {
    # my @leftCellCount = map { 0 } (1..$#leftCell);
    #
    # foreach my $pattern (keys %uniqComp) {
    #     foreach my $line (@list) {
    #         if ( $line =~ /$pattern/ ) {
    #             $uniqComp{$pattern}++;
    #         }
    #     }
    # }
    # foreach my $pattern (keys %uniqComp) {
    #     print "$pattern : $uniqComp{$pattern} \n";
    # }
    #

    my $graph = GraphViz2->new(
        edge   => {color => 'grey'},
        global => {directed => 2},
    );
    # foreach my $pattern (keys %uniqComp) {
    #     $graph->add_node($pattern);
    # }
    #
    foreach my $i (0 .. $#leftCell) {
        my $line = $list[$i];
        my @row = split /,/, $line;
        foreach my $j (0 .. $#row) {
            try {
                $graph->add_edge(from => $leftCell[$i], to => $row[$j]);
            } catch {
                print "error: $_\n";
            }
        }
    }
    my $format = 'png';  # You can choose other formats like 'pdf', 'svg', etc.
    my $output_file = 'undirected_graph.' . $format;
    $graph->run(format => $format, output_file => $output_file);

    print "Graph visualization saved to $output_file\n";

# Check if two vertices are connected


    # foreach my $i (0..$#leftCell) {
    #     foreach my $line (@list) {
    #         if ( $line =~ /$leftCell[$i]/ ) {
    #             $leftCellCount[$i]++;
    #         }
    #     }
    #     print "left component: $leftCell[$i] : $leftCellCount[$i]\n";
    # }

}

solve_part1();
