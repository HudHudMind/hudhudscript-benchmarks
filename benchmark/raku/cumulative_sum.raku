my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my @arr; for 1..100000 { @arr.push($_); }; my $start = now * 1000; my @res; my $sum = 0;
for 0..99999 { $sum += @arr[$_]; @res.push($sum); }; my $end = now * 1000; say "Last sum: " ~ @res[*-1]; say "Time: " ~ ($end - $start).Int ~ "ms";