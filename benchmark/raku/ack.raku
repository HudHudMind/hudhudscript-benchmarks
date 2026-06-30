my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub ack($m, $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 return $m == 0 ?? $n + 1 !! ($n == 0 ?? ack($m - 1, 1) !! ack($m - 1, ack($m, $n - 1))); }; my $start = now * 1000;
my $result = ack(3, 6);
my $end = now * 1000;
say "Result: " ~ $result; say "Time: " ~ ($end - $start).Int ~ "ms";