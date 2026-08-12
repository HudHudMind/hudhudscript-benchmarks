sub fact($n) { return 1 if $n <= 1; $n * fact($n - 1) }
my $start = now * 1000;
my $res = fact(150);
my $end = now * 1000;
say "Result: $res";
say "Time: " ~ ($end - $start).Int ~ "ms";
