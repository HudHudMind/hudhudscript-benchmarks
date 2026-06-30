my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub hanoi($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 return $n == 1 ?? 1 !! 2 * hanoi($n - 1) + 1; }; my $start = now * 1000; my $res = hanoi(20); my $end = now * 1000;
say "Moves: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";