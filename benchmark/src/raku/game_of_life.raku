my $G = 96; my $T = 100; my $seed = 12345;
sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my @a; for ^$G { my @r; for ^$G { @r.push(ri(100) < 35 ?? 1 !! 0) }; @a.push(@r) }
my @b; for ^$G { my @r; @r.push(0) for ^$G; @b.push(@r) };
my $start = now * 1000;
for ^$T {
    for ^$G -> $i { for ^$G -> $j {
        my $nbr = 0;
        for -1,0,1 -> $di { for -1,0,1 -> $dj {
            next if $di == 0 && $dj == 0;
            $nbr += @a[($i + $di) % $G][($j + $dj) % $G] } }
        @b[$i][$j] = (@a[$i][$j] == 1 && ($nbr == 2 || $nbr == 3)) || (@a[$i][$j] == 0 && $nbr == 3) ?? 1 !! 0 } }
    my @t = @a; @a = @b; @b = @t }
my $alive = 0; for ^$G -> $i { for ^$G -> $j { $alive += @a[$i][$j] } }
my $end = now * 1000;
say "Result: $alive"; say "Time: " ~ ($end - $start).Int ~ "ms";
