my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub nsqrt($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $x = $n; my $y = 1e0; my $e = 1e-6; while $x - $y > $e { $x = ($x + $y) / 2; $y = $n / $x; }; return $x; }; my $start = now * 1000; my $res = 0; for 1..100000 { $res = nsqrt(1e6); }; my $end = now * 1000; say "Sqrt: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";