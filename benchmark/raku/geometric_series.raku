my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my $start = now * 1000; my $s = 0e0; my $r = 0.999e0; my $term = 1e0;
for 0..999999 { $s += $term; $term *= $r; }; my $end = now * 1000; say "Sum: " ~ $s; say "Time: " ~ ($end - $start).Int ~ "ms";