my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub mv(@arr) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $n = @arr.elems; my $sum = 0; for @arr -> $x { $sum += $x; }; my $mean = $sum / $n;
    my $var = 0; for @arr -> $x { my $d = $x - $mean; $var += $d * $d; }; return $var / $n; }; my $start = now * 1000; my @arr = 1..10000; my $res = 0; for 1..10000 { $res = mv(@arr); }; my $end = now * 1000; say "Var: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";