my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
sub pm($b, $e, $m) { my $r = 1; my $bb = $b; my $ee = $e;
    while $ee > 0 { if $ee +& 1 { $r = ($r * $bb) % $m }; $ee +>= 1; $bb = ($bb * $bb) % $m }; $r }
sub ip($n) { return 0 if $n < 2; return 1 if $n == 2; return 0 if $n % 2 == 0;
    my $d = $n - 1; my $s = 0; while $d % 2 == 0 { $d +>= 1; $s++ }
    for (2, 3, 5, 7) -> $a { next if $a >= $n; my $x = pm($a, $d, $n);
        next if $x == 1 || $x == $n - 1; my $ok = 0;
        for ^($s - 1) { $x = ($x * $x) % $n; if $x == $n - 1 { $ok = 1; last } }
        return 0 if !$ok }; 1 }
my $K = 2000; my $cnt = 0; my $start = now * 1000;
for ^$K { my $n = 1000000001 + 2 * ri(500000000); $cnt++ if ip($n) }
my $end = now * 1000;
say "Result: $cnt"; say "Time: " ~ ($end - $start).Int ~ "ms";
