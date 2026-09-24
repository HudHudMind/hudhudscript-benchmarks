sub fib($n) {
    return $n < 2 ?? $n !! fib($n - 1) + fib($n - 2); }; my $start = now * 1000; my $res = fib(30); my $end = now * 1000;
say "Result: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";