my $n = 1000; my @a = (1..$n).reverse; my $start = now * 1000;
sub heapify(@a, $n, $i) {
    my $big = $i; my $l = 2 * $i + 1; my $r = 2 * $i + 2;
    $big = $l if $l < $n && @a[$l] > @a[$big];
    $big = $r if $r < $n && @a[$r] > @a[$big];
    if $big != $i { (@a[$i], @a[$big]) = (@a[$big], @a[$i]); heapify(@a, $n, $big) }
}
my $i = ($n/2).Int - 1; while $i >= 0 { heapify(@a, $n, $i); $i-- }
$i = $n - 1; while $i > 0 { (@a[0], @a[$i]) = (@a[$i], @a[0]); heapify(@a, $i, 0); $i-- }
my $end = now * 1000;
say "Result: {@a[0]}/{@a[$n-1]}";
say "Time: " ~ ($end - $start).Int ~ "ms";
