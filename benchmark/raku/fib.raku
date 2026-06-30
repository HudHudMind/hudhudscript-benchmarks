my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub fib($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 return $n < 2 ?? $n !! fib($n - 1) + fib($n - 2); }; my $start = now * 1000; my $res = fib(30); my $end = now * 1000;
say "fib(30) = " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";