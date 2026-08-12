sub collatz($n) {
    my $len = 0; my $curr = $n;
    while $curr != 1 { if $curr % 2 == 0 { $curr = $curr div 2; } else { $curr = 3 * $curr + 1; }; $len++; }; return $len; }; my $start = now * 1000; my $max_steps = 0; my $max_n = 0;
for 1..10000 -> $i { my $l = collatz($i); if $l > $max_steps { $max_steps = $l; $max_n = $i; } }; my $end = now * 1000; say "Result: " ~ $max_steps; say "Time: " ~ ($end - $start).Int ~ "ms";