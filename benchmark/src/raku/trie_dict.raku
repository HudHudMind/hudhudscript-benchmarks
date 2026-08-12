my $W = 20000; my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my $nodes = 1; my @children = 0 xx 26; my @terminal = 0;
sub nc() { for ^26 { @children.push(0) }; @terminal.push(0); $nodes++; $nodes - 1 }
my $start = now * 1000;
for ^$W { my $l = 3 + ri(6); my $cur = 0;
    for ^$l { my $c = ri(26); my $idx = $cur * 26 + $c;
        if @children[$idx] == 0 { @children[$idx] = nc() }; $cur = @children[$idx] }
    @terminal[$cur] = 1 }
my $hits = 0; $seed = 12345;
for ^$W { my $l = 3 + ri(6); my $cur = 0;
    for ^$l { my $c = ri(26); my $idx = $cur * 26 + $c;
        if @children[$idx] == 0 { $cur = 0; last }; $cur = @children[$idx] }
    if $cur != 0 && @terminal[$cur] == 1 { $hits++ } }
$seed = 54321;
for ^$W { my $l = 3 + ri(6); my $cur = 0;
    for ^$l { my $c = ri(26); my $idx = $cur * 26 + $c;
        if @children[$idx] == 0 { $cur = 0; last }; $cur = @children[$idx] }
    if $cur != 0 && @terminal[$cur] == 1 { $hits++ } }
my $end = now * 1000; say "Result: {$nodes}_{$hits}";
say "Time: " ~ ($end - $start).Int ~ "ms";
