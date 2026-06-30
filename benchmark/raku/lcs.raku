my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub lcs($X, $Y, $m, $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my @L; for 0..$m -> $i { my @row; for 0..$n -> $j {
        if $i == 0 || $j == 0 { @row.push(0); } elsif substr($X, $i-1, 1) eq substr($Y, $j-1, 1) {
        @row.push(@L[$i-1][$j-1] + 1); } else { my $a = @L[$i-1][$j]; my $b = @row[$j-1]; @row.push($a > $b ?? $a !! $b); } }; @L.push(@row); }; return @L[$m][$n]; }; my $start = now * 1000; my $S1 = "A" x 50 ~ "B" x 50; my $S2 = "B" x 50 ~ "C" x 50;
my $res = 0; for 1..10 { $res = lcs($S1, $S2, 100, 100); }; my $end = now * 1000; say "LCS Length: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";