my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my %memo; sub fib_memo($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 return $n if $n <= 1; return %memo{$n} if %memo{$n}:exists; %memo{$n} = fib_memo($n - 1) + fib_memo($n - 2); return %memo{$n}; }; my $start = now * 1000; my $sum = 0; for 1..10000 { %memo = (); $sum += fib_memo(500); }; my $end = now * 1000; say "Sum: " ~ $sum; say "Time: " ~ ($end - $start).Int ~ "ms";