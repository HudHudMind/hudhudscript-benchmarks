my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my @arr; for 0..9999 { @arr.push($_); }; my $sum = 0; my $start = now * 1000;
for 0..9999 { $sum = $sum + @arr[$_]; }; my $end = now * 1000;
say "Sum: " ~ $sum; say "Time: " ~ ($end - $start).Int ~ "ms";