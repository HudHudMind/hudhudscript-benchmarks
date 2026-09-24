my $C = 65536; my @keys = 0 xx $C; my @vals = 0 xx $C; my @state = 0 xx $C;
my $seed = 12345; sub ri($n) { $seed = ($seed * 16807) % 2147483647; $seed % $n }
my ($I, $L, $D) = (40000, 80000, 20000);
my ($fnd, $dlt, $acc) = (0, 0, 0); my $start = now * 1000;
for ^$I { my $k = ri(1000000) + 1; my $h = ($k * 16807) % $C;
    while @state[$h] == 1 { $h = ($h + 1) % $C }; @keys[$h] = $k; @vals[$h] = $k % 97; @state[$h] = 1 }
for ^$L { my $k = ri(1000000) + 1; my $h = ($k * 16807) % $C;
    while @state[$h] != 0 { if @state[$h] == 1 && @keys[$h] == $k { $fnd++; $acc = ($acc + @vals[$h]) % 1000003; last }; $h = ($h + 1) % $C } }
for ^$D { my $k = ri(1000000) + 1; my $h = ($k * 16807) % $C;
    while @state[$h] != 0 { if @state[$h] == 1 && @keys[$h] == $k { @state[$h] = 2; $dlt++; last }; $h = ($h + 1) % $C } }
my $end = now * 1000;
say "Result: {$fnd}_{$dlt}_{$acc}"; say "Time: " ~ ($end - $start).Int ~ "ms";
