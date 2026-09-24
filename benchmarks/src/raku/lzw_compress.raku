my $M = 400000; my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my @syms; my $i = 0;
while $i < $M { if $i >= 20 && ri(10) < 4 { my $s = $i - 20; for ^20 { @syms.push(@syms[$s + $_]) }; $i += 20 }
    else { @syms.push(ri(4)); $i++ } }
my $DS = 4096; my @dic = 0 xx ($DS * 4); my $nc = 5; my @out; my $cur = @syms[0] + 1; $i = 1; my $start = now * 1000;
while $i < @syms { my $s = @syms[$i]; my $cand = @dic[$cur * 4 + $s];
    if $cand != 0 { $cur = $cand } else { @out.push($cur); if $nc < $DS { @dic[$cur * 4 + $s] = $nc; $nc++ }; $cur = $s + 1 }; $i++ }
@out.push($cur); my $oc = @out.elems; my $sm = 0; for ^$oc { $sm = ($sm + @out[$_] * $_) % 1000003 }
my $end = now * 1000; say "Result: {$oc}_{$sm}"; say "Time: " ~ ($end - $start).Int ~ "ms";
