my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub fact($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 return $n <= 1 ?? 1 !! $n * fact($n - 1); }; my $start = now * 1000; my $res = 0; for 1..10000 { $res = fact(150); }; my $end = now * 1000; say "Result: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";