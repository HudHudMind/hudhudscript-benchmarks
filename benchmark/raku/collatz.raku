my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub collatz($n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $len = 0; my $curr = $n;
    while $curr != 1 { if $curr % 2 == 0 { $curr = $curr div 2; } else { $curr = 3 * $curr + 1; }; $len++; }; return $len; }; my $start = now * 1000; my $max_steps = 0; my $max_n = 0;
for 1..10000 -> $i { my $l = collatz($i); if $l > $max_steps { $max_steps = $l; $max_n = $i; } }; my $end = now * 1000; say "Max steps: " ~ $max_steps ~ " at n=" ~ $max_n; say "Time: " ~ ($end - $start).Int ~ "ms";