my $n = 20000; my $seed = 12345;
sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my @et; my @ew; my @deg = 0 xx $n; my @sof = 0 xx $n;
for ^$n -> $i { @et.push(($i + 1) % $n); @ew.push(1 + ri(9)); @deg[$i]++ }
for ^$n -> $i { for ^5 { my $t = ri($n); @et.push($t); @ew.push(1 + ri(99)); @deg[$i]++ } }
my $off = 0; for ^$n -> $i { @sof[$i] = $off; $off += @deg[$i] }
my @hd; my @hn; my $hsz = 0;
sub hp($d, $nd) { @hn[$hsz]=$nd; @hd[$hsz]=$d; my $i2=$hsz; $hsz++;
    while $i2 > 0 { my $p = ($i2 - 1) div 2; last if @hd[$p] <= @hd[$i2];
        (@hd[$i2], @hd[$p]) = (@hd[$p], @hd[$i2]); (@hn[$i2], @hn[$p]) = (@hn[$p], @hn[$i2]); $i2 = $p } }
sub hpop() { return -1 if $hsz == 0; my $r = @hn[0]; $hsz--;
    @hn[0] = @hn[$hsz]; @hd[0] = @hd[$hsz]; my $i2 = 0;
    loop { my $l = 2 * $i2 + 1; my $r2 = 2 * $i2 + 2; my $s = $i2;
        $s = $l if $l < $hsz && @hd[$l] < @hd[$s]; $s = $r2 if $r2 < $hsz && @hd[$r2] < @hd[$s]; last if $s == $i2;
        (@hd[$i2], @hd[$s]) = (@hd[$s], @hd[$i2]); (@hn[$i2], @hn[$s]) = (@hn[$s], @hn[$i2]); $i2 = $s }; $r }
my $INF = 999999999; my @dist = $INF xx $n; my @vis = 0 xx $n; @dist[0] = 0; hp(0, 0); my $start = now * 1000;
while $hsz > 0 { my $u = hpop(); last if $u < 0; next if @vis[$u] == 1; @vis[$u] = 1; my $d = @dist[$u]; my $base = @sof[$u];
    for ^@deg[$u] { my $v = @et[$base + $_]; my $w = @ew[$base + $_]; my $nd = $d + $w;
        if $nd < @dist[$v] { @dist[$v] = $nd; hp($nd, $v) } } }
my $sm = 0; $sm += @dist[$_] for ^$n; my $end = now * 1000;
say "Result: " ~ ($sm % 1000003); say "Time: " ~ ($end - $start).Int ~ "ms";
