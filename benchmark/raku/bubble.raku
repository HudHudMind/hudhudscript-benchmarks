my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub bubbleSort(@arr) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $n = @arr.elems; for 0..$n-1 -> $i { for 0..$n-$i-2 -> $j {
        if @arr[$j] > @arr[$j+1] { my $t = @arr[$j]; @arr[$j] = @arr[$j+1]; @arr[$j+1] = $t; } } } }; my @arr; my $start = now * 1000; for 1..100 { @arr = (1..500).reverse.Array; bubbleSort(@arr); }; my $end = now * 1000; say "First: " ~ @arr[0]; say "Last: " ~ @arr[*-1]; say "Time: " ~ ($end - $start).Int ~ "ms";