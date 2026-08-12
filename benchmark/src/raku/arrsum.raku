my @arr; for 0..9999 { @arr.push($_); }; my $sum = 0; my $start = now * 1000;
for 0..9999 { $sum = $sum + @arr[$_]; }; my $end = now * 1000;
say "Result: " ~ $sum; say "Time: " ~ ($end - $start).Int ~ "ms";