my $N = 100000;
my $seed = 12345;
my $acc = 0;
my $start = now * 1000;

my $head = Nil;
for ^$N {
    $seed = ($seed * 16807) % 2147483647;
    $head = { value => $seed % 10000, next => $head };
}

my ($prev, $cur) = (Nil, $head);
for ^$N {
    my $nxt = $cur<next>;
    $cur<next> = $prev;
    $prev = $cur;
    $cur = $nxt;
}

my ($pos, $walk) = (0, $prev);
for ^$N {
    $acc = ($acc + $walk<value> * $pos) % 1000003;
    $pos++;
    $walk = $walk<next>;
}

my $end = now * 1000;
say "Result: $acc";
say "Time: " ~ ($end - $start).Int ~ "ms";
