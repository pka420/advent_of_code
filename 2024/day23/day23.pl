#!/opt/local/bin/perl
use strict;
use warnings;
use Graph;

my @connections;

my $filename = 'input.txt';
open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";

while (my $line = <$fh>) {
	chomp $line;
	push @connections, $line;
}

close $fh;

my $graph = Graph->new(undirected => 1);
for my $connection (@connections) {
    my ($start, $end) = split('-', $connection);
    $graph->add_edge($start, $end);
}

sub part1 {
	my @triplets;

	for my $v ($graph->vertices) {
		my @neighbors = $graph->neighbours($v);

		for my $i (0 .. $#neighbors - 1) {
			for my $j ($i + 1 .. $#neighbors) {
				my ($n1, $n2) = ($neighbors[$i], $neighbors[$j]);

				if ($graph->has_edge($n1, $n2)) {
					push @triplets, join('-', sort($v, $n1, $n2));
				}
			}
		}
	}

	my %seen;
	@triplets = grep { !$seen{$_}++ } @triplets;

	#print "Triplets:\n", join("\n", @triplets), "\n";

	my $count = 0;

	for my $i ( 0 .. $#triplets) {
		my ($n1, $n2, $n3) = split('-', $triplets[$i]);
		if (substr($n1, 0, 1) eq 't' ||
			substr($n2, 0, 1) eq 't' ||
			substr($n3, 0, 1) eq 't') {
			$count++;
		}
	}

	print("count : ", $count, "\n");
}

#part1();

sub part2 {
	my @triplets;

	for my $v ($graph->vertices) {
		my @neighbors = $graph->neighbours($v);
		for my $i (0 .. $#neighbors - 1) {
			for my $j ($i + 1 .. $#neighbors) {
				my ($n1, $n2) = ($neighbors[$i], $neighbors[$j]);
				if ($graph->has_edge($n1, $n2)) {
					push @triplets, [sort($v, $n1, $n2)];
				}
			}
		}
	}

	my %seen;
	@triplets = grep { !$seen{join('-', @$_)}++ } @triplets;

	my $triplet_graph = Graph->new(undirected => 1);

	for my $t1 (@triplets) {
		my $t1_str = join('-', @$t1);
		$triplet_graph->add_vertex($t1_str);

		for my $t2 (@triplets) {
			my $t2_str = join('-', @$t2);

			my %nodes = map { $_ => 1 } @$t1, @$t2;
			if (scalar(keys %nodes) <= 4) {
				$triplet_graph->add_edge($t1_str, $t2_str);
			}
		}
	}

	my @largest_component;
	for my $cc ($triplet_graph->connected_components) {
		@largest_component = @$cc if scalar(@$cc) > scalar(@largest_component);
	}

	print "Largest set of connected triplets:\n";
	print join("\n", @largest_component), "\n";

	my $str = join("-", @largest_component);

	my @elements = split('-', $str);
	my %seen2 = map { $_ => 1 } @elements;
	my @sorted_unique = sort keys %seen2;

	my $output = join(',', @sorted_unique);

	print("password: ", $output);
}

part2();
