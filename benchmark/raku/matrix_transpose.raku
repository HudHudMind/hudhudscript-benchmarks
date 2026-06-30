my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub transpose(@A, $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my @B; for 0..$n-1 -> $i { my @row; for 0..$n-1 -> $j { @row.push(@A[$j][$i]); }; @B.push(@row); }; return @B; }; my $start = now * 1000; my @A; for 0..499 -> $i { my @row; for 0..499 -> $j { @row.push($i + $j); }; @A.push(@row); }; my $res = 0; for 1..100 { my @B = transpose(@A, 500); $res = @B[0][0]; }; my $end = now * 1000; say "First: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";