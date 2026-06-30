my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my $n = 150; my @A; my @B; my @C;
for 0..$n-1 -> $i { my @rA; my @rB; my @rC; for 0..$n-1 -> $j {
    @rA.push($i + $j); @rB.push($i - $j); @rC.push(0); }; @A.push(@rA); @B.push(@rB); @C.push(@rC); }; my $start = now * 1000;
for 0..$n-1 -> $i { for 0..$n-1 -> $j { for 0..$n-1 -> $k { @C[$i][$j] += @A[$i][$k] * @B[$k][$j]; } } }; my $end = now * 1000; say "Corner: " ~ @C[0][0] ~ "/" ~ @C[$n-1][$n-1]; say "Time: " ~ ($end - $start).Int ~ "ms";