my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub eval($x, @coeffs) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $res = 0; for @coeffs.reverse -> $c { $res = $res * $x + $c; }; return $res; }; my $start = now * 1000; my @coeffs = 1..1000; my $res = 0; for 1..100000 { $res = eval(1.0001e0, @coeffs); }; my $end = now * 1000; say "Eval: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";