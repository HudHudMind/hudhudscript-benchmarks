my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub insertSort(@arr) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $n = @arr.elems; for 1..$n-1 -> $i { my $key = @arr[$i]; my $j = $i - 1;
        while $j >= 0 && @arr[$j] > $key { @arr[$j + 1] = @arr[$j]; $j--; }; @arr[$j + 1] = $key; } }; my @arr; my $start = now * 1000; for 1..10 { @arr = (1..1000).reverse.Array; insertSort(@arr); }; my $end = now * 1000; say "First: " ~ @arr[0]; say "Last: " ~ @arr[*-1]; say "Time: " ~ ($end - $start).Int ~ "ms";