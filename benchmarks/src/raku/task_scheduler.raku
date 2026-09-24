my $T = 300000; my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my @pq; my $qh = 0; my @wq; my $wh = 0; my @sq; my $sh = 0;
my ($made, $acc, $sunk) = (0, 0, 0); my $start = now * 1000;
for ^$T { $made++;
    if $made % 3 != 0 { @wq.push($made % 100) }
    if $wh < @wq.elems { my $pkt = @wq[$wh]; $wh++; $acc = ($acc + $pkt * 7) % 1000003;
        if $pkt > 50 { @sq.push($pkt) } }
    if $sh < @sq.elems { $sh++; $sunk++ } }
my $end = now * 1000;
say "Result: {$made}_{$acc}_{$sunk}"; say "Time: " ~ ($end - $start).Int ~ "ms";
