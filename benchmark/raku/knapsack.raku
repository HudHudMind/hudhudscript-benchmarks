my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub knapsack($W, @wt, @val, $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my @K; for 0..$n -> $i { my @row; for 0..$W -> $w {
        if $i == 0 || $w == 0 { @row.push(0); } elsif @wt[$i-1] <= $w {
        my $a = @val[$i-1] + @K[$i-1][$w - @wt[$i-1]]; my $b = @K[$i-1][$w]; @row.push($a > $b ?? $a !! $b);
        } else { @row.push(@K[$i-1][$w]); } }; @K.push(@row); }; return @K[$n][$W]; }; my $start = now * 1000; my @wt = (1..50).Array; my @val = (1..50).Array; for 0..49 { @val[$_] = @val[$_] * 2; }; my $res = 0; for 1..10 { $res = knapsack(100, @wt, @val, 50); }; my $end = now * 1000; say "Max Value: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";