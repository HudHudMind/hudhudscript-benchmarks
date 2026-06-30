my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my @v1 = 1..500000; my @v2 = 2..500001; my $start = now * 1000; my $s = 0;
for 0..499999 -> $i { $s += @v1[$i] * @v2[$i]; }; my $end = now * 1000; say "Dot: " ~ $s; say "Time: " ~ ($end - $start).Int ~ "ms";