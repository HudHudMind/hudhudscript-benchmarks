my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my $start = now * 1000;
my $result = 1;
for 2..10000 -> $i { $result *= $i; }; my $end = now * 1000;
say "Result: " ~ $result;
say "Time: " ~ ($end - $start).Int ~ "ms";
