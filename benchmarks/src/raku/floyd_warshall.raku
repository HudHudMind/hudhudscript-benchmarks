my $n = 150; my $INF = 999999999; my @dist;
for ^$n -> $i { my @r; for ^$n -> $j { @r.push($i == $j ?? 0 !! $INF) }; @dist.push(@r) }
my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
for ^$n -> $i { for ^4 { my $t = ($i * 7 + $_ * 13 + 1) % $n; @dist[$i][$t] = 1 + (($i + $_) % 50) if $t != $i } }
my $start = now * 1000;
for ^$n -> $k { for ^$n -> $i { my $dik = @dist[$i][$k]; if $dik != $INF { for ^$n -> $j { my $nd = $dik + @dist[$k][$j]; @dist[$i][$j] = $nd if $nd < @dist[$i][$j] } } } }
my ($reach, $sm) = (0, 0); for ^$n -> $i { for ^$n -> $j { if @dist[$i][$j] < $INF { $reach++; $sm += @dist[$i][$j] } } }
my $end = now * 1000;
say "Result: {$reach}_{$sm % 1000003}"; say "Time: " ~ ($end - $start).Int ~ "ms";
