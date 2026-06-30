my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub countBits($n is copy) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $count = 0; while $n > 0 { $count += $n +& 1; $n +>= 1; }; return $count; }; my $start = now * 1000; my $total = 0; for 1..100000 { $total += countBits($_); }; my $end = now * 1000; say "Total: " ~ $total; say "Time: " ~ ($end - $start).Int ~ "ms";