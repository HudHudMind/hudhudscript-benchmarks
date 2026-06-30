my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my $s = "a" x 50000 ~ "b"; my $start = now * 1000; my $c = 0;
for 1..1000 { my $idx = $s.index("b"); $c++ if $idx.defined; }; my $end = now * 1000; say "Found: " ~ $c; say "Time: " ~ ($end - $start).Int ~ "ms";