my $start = now * 1000;
my $result = 1;
for 2..10000 -> $i { $result *= $i; }; my $end = now * 1000;
say "Result: " ~ $result;
say "Time: " ~ ($end - $start).Int ~ "ms";
