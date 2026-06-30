my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub gcd($a, $b) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 return $b == 0 ?? $a !! gcd($b, $a % $b); }; my $start = now * 1000; my $result = 0; for 1..10000 -> $i { $result = gcd($i * 12345, $i * 6789 + 1); }; my $end = now * 1000; say "Result: " ~ $result; say "Time: " ~ ($end - $start).Int ~ "ms";