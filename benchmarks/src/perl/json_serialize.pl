use Time::HiRes qw(time);
my $seed = 12345;
sub ri { my $m = shift; $seed = ($seed * 16807) % 2147483647; return $seed % $m; }

sub gen {
    my $depth = shift;
    return ri(100000) if $depth == 7;
    my %node;
    $node{"a"} = ri(4) == 0 ? ri(100000) : gen($depth + 1);
    $node{"b"} = ri(4) == 0 ? ri(100000) : gen($depth + 1);
    $node{"c"} = ri(4) == 0 ? ri(100000) : gen($depth + 1);
    $node{"s"} = "x" . ri(1000);
    return \%node;
}

sub count_nodes {
    my $node = shift;
    return 0 if !ref($node) || ref($node) ne "HASH";
    return 1 + count_nodes($node->{"a"}) + count_nodes($node->{"b"}) + count_nodes($node->{"c"});
}

sub serialize {
    my $node = shift;
    return $node if !ref($node);
    my @parts = ();
    push @parts, '{"a":';
    push @parts, serialize($node->{"a"});
    push @parts, ',"b":';
    push @parts, serialize($node->{"b"});
    push @parts, ',"c":';
    push @parts, serialize($node->{"c"});
    push @parts, ',"s":"';
    push @parts, $node->{"s"};
    push @parts, '"}';
    return join("", @parts);
}

my $tree = gen(0);
my $nc = count_nodes($tree);
my $start = time();
my $total = 0;
for (1..50) { $total += length(serialize($tree)); }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: " . ($total % 1000003) . "_" . $nc . "\n";
printf "Time: %.0fms\n", $ms;
