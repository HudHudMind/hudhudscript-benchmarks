my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub fib($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 if $n <= 1 { return $n; }; my $a = 0; my $b = 1; for 2..$n { my $t = $a + $b; $a = $b; $b = $t; }; return $b; }; my $start = now * 1000; my $s = 0; for 1..10000 { $s += fib(1000); }; my $end = now * 1000; say "Sum: " ~ $s; say "Time: " ~ ($end - $start).Int ~ "ms";