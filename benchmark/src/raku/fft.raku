my $N = 4096; my $PI = 3.141592653589793e0; my @re; my @im;
for ^$N { @re.push(sin($_ * 0.017e0) + 0.5e0 * sin($_ * 0.31e0)); @im.push(0e0) }
my @br; for ^$N -> $i { my ($rev, $p2) = (0, 1); for ^12 -> $j { $rev = $rev * 2 + (($i div $p2) % 2); $p2 *= 2 }; @br.push($rev) }
my $R = 50; my $fs = 0e0; my $start = now * 1000;
for ^$R { my @cr; my @ci; for ^$N { my $b = @br[$_]; @cr.push(@re[$b]); @ci.push(@im[$b]) }
    my $step = 2; while $step <= $N { my $half = $step div 2; my $ang = (-2e0 * $PI) / $step; my $wr = cos($ang); my $wi = sin($ang);
        loop (my $k = 0; $k < $N; $k += $step) { my ($twr, $twi) = (1e0, 0e0);
            for ^$half { my $ei = $k + $_; my $oi = $k + $_ + $half;
                my $tr = $twr * @cr[$oi] - $twi * @ci[$oi]; my $ti = $twr * @ci[$oi] + $twi * @cr[$oi];
                @cr[$oi] = @cr[$ei] - $tr; @ci[$oi] = @ci[$ei] - $ti; @cr[$ei] += $tr; @ci[$ei] += $ti;
                my $nwr = $twr; $twr = $nwr * $wr - $twi * $wi; $twi = $nwr * $wi + $twi * $wr } }; $step *= 2 }
    my $sm = 0e0; $sm += @cr[$_] * @cr[$_] + @ci[$_] * @ci[$_] for ^$N; $fs = $sm }
my $end = now * 1000;
say "Result: " ~ round($fs); say "Time: " ~ ($end - $start).Int ~ "ms";
