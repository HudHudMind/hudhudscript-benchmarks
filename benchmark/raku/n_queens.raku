my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub solve($r, $n, @cols, @d1, @d2) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 return 1 if $r == $n; my $c = 0; for 0..$n-1 -> $i {
        if !@cols[$i] && !@d1[$r+$i] && !@d2[$r-$i+$n] { @cols[$i] = 1; @d1[$r+$i] = 1; @d2[$r-$i+$n] = 1;
        $c += solve($r+1, $n, @cols, @d1, @d2); @cols[$i] = 0; @d1[$r+$i] = 0; @d2[$r-$i+$n] = 0; } }; return $c; }; my $start = now * 1000; my $res = 0; for 1..100 { my @c; my @d1; my @d2; $res = solve(0, 8, @c, @d1, @d2); }; my $end = now * 1000; say "Count: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";