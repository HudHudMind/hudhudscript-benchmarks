use Time::HiRes qw(time);
my $n = 20000; my $seed = 12345;
sub ri { my $m = shift; $seed = ($seed * 16807) % 2147483647; $seed % $m }
my (@et, @ew, @deg, @sof);
for my $i (0..$n-1) { $deg[$i] = 0; $sof[$i] = 0 }

my $idx = 0;
for my $i (0..$n-1) { $et[$idx] = ($i+1) % $n; $ew[$idx] = 1 + ri(9); $deg[$i]++; $idx++; }
for my $i (0..$n-1) { for (1..5) { my $t = ri($n); $et[$idx] = $t; $ew[$idx] = 1 + ri(99); $deg[$i]++; $idx++; } }

my $off = 0;
for my $i (0..$n-1) { $sof[$i] = $off; $off += $deg[$i]; }

my $INF = 999999999;
my (@hd, @hn, $hsz) = ((), (), 0);
sub hp { my ($d, $nd) = @_; $hn[$hsz] = $nd; $hd[$hsz] = $d; my $i = $hsz; $hsz++;
    while ($i > 0) { my $p = int(($i-1)/2); last if $hd[$p] <= $hd[$i];
        @hd[$i,$p] = @hd[$p,$i]; @hn[$i,$p] = @hn[$p,$i]; $i = $p; } }
sub hpop { return -1 if $hsz == 0; my $r = $hn[0]; $hsz--; $hd[0] = $hd[$hsz]; $hn[0] = $hn[$hsz];
    my $i = 0;
    while (1) { my $l = 2*$i+1; my $r2 = 2*$i+2; my $s = $i;
        $s = $l if $l < $hsz && $hd[$l] < $hd[$s]; $s = $r2 if $r2 < $hsz && $hd[$r2] < $hd[$s];
        last if $s == $i; @hd[$i,$s] = @hd[$s,$i]; @hn[$i,$s] = @hn[$s,$i]; $i = $s; } $r; }

my (@dist, @vis);
for my $i (0..$n-1) { $dist[$i] = $INF; $vis[$i] = 0; }
$dist[0] = 0; hp(0, 0);
my $start = time();

while ($hsz > 0) { my $u = hpop(); last if $u < 0; next if $vis[$u] == 1; $vis[$u] = 1;
    my $d = $dist[$u]; my $base = $sof[$u];
    for my $k (0..$deg[$u]-1) { my $v = $et[$base+$k]; my $w = $ew[$base+$k]; my $nd = $d + $w;
        if ($nd < $dist[$v]) { $dist[$v] = $nd; hp($nd, $v); } } }

my $sm = 0;
for my $i (0..$n-1) { $sm = ($sm + $dist[$i]) % 1000003; }
my $end = time(); my $ms = ($end - $start) * 1000;
print "Result: $sm\n"; printf "Time: %.0fms\n", $ms;
