my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub heapify(@arr, $n, $i) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $largest = $i; my $l = 2 * $i + 1; my $r = 2 * $i + 2;
    if $l < $n && @arr[$l] > @arr[$largest] { $largest = $l; }; if $r < $n && @arr[$r] > @arr[$largest] { $largest = $r; };
    if $largest != $i { my $t = @arr[$i]; @arr[$i] = @arr[$largest]; @arr[$largest] = $t; heapify(@arr, $n, $largest); } }
sub heapSort(@arr) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $n = @arr.elems; for (0..$n div 2 - 1).reverse -> $i { heapify(@arr, $n, $i); };
    for (1..$n - 1).reverse -> $i { my $t = @arr[0]; @arr[0] = @arr[$i]; @arr[$i] = $t; heapify(@arr, $i, 0); }; }; my @arr; my $start = now * 1000; for 1..100 { @arr = (1..1000).reverse.Array; heapSort(@arr); }; my $end = now * 1000; say "First: " ~ @arr[0]; say "Last: " ~ @arr[*-1]; say "Time: " ~ ($end - $start).Int ~ "ms";