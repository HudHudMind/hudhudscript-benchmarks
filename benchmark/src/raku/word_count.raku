my $M = 500000; my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my @d; for ^2000 { @d.push('w' ~ $_) }
my %c; for @d -> $w { %c{$w} = 0 }
my $start = now * 1000;
for ^$M { my $w = @d[ri(2000)]; %c{$w} = %c{$w} + 1 }
my ($mc, $mw) = (0, '');
for @d -> $w { my $v = %c{$w};
    if $mc == 0 { $mc = $v; $mw = $w }
    elsif $v > $mc { $mc = $v; $mw = $w } }
my $end = now * 1000;
say "Result: {$mc}_{$mw}"; say "Time: " ~ ($end - $start).Int ~ "ms";
