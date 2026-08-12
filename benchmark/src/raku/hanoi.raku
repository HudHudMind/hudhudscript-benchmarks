sub hanoi($n) { return 1 if $n == 1; hanoi($n - 1) + 1 + hanoi($n - 1) }
my $start = now * 1000;
my $res = hanoi(20);
my $end = now * 1000;
say "Result: $res";
say "Time: " ~ ($end - $start).Int ~ "ms";
