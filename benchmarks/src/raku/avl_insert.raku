my $n = 100000;
my $seed = 12345;
sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m; }

my $sz = $n + 10;
my @key = 0 xx $sz;
my @left = 0 xx $sz;
my @right = 0 xx $sz;
my @height = 0 xx $sz;
my $nodes = 0;

sub new-node($k) {
    $nodes++;
    @key[$nodes] = $k;
    @left[$nodes] = 0;
    @right[$nodes] = 0;
    @height[$nodes] = 1;
    return $nodes;
}
sub get-h($nd) { return $nd == 0 ?? 0 !! @height[$nd]; }
sub upd-h($nd) {
    my $hl = get-h(@left[$nd]);
    my $hr = get-h(@right[$nd]);
    @height[$nd] = ($hl > $hr ?? $hl !! $hr) + 1;
}
sub bal($nd) { return get-h(@left[$nd]) - get-h(@right[$nd]); }
sub rot-r($y) {
    my $x = @left[$y]; my $T = @right[$x];
    @right[$x] = $y; @left[$y] = $T;
    upd-h($y); upd-h($x); return $x;
}
sub rot-l($x) {
    my $y = @right[$x]; my $T = @left[$y];
    @left[$y] = $x; @right[$x] = $T;
    upd-h($x); upd-h($y); return $y;
}
sub insert($nd, $k) {
    return new-node($k) if $nd == 0;
    if $k < @key[$nd] { @left[$nd] = insert(@left[$nd], $k); }
    elsif $k > @key[$nd] { @right[$nd] = insert(@right[$nd], $k); }
    else { return $nd; }
    upd-h($nd); my $b = bal($nd);
    return rot-r($nd) if $b > 1 && $k < @key[@left[$nd]];
    return rot-l($nd) if $b < -1 && $k > @key[@right[$nd]];
    if $b > 1 && $k > @key[@left[$nd]] { @left[$nd] = rot-l(@left[$nd]); return rot-r($nd); }
    if $b < -1 && $k < @key[@right[$nd]] { @right[$nd] = rot-r(@right[$nd]); return rot-l($nd); }
    return $nd;
}

my $root = 0;
for ^$n { $root = insert($root, ri(1000000)); }

my $start = now * 1000;
my $c = 0; my $idx = 0; my @stack; my $cur = $root;
while @stack || $cur != 0 {
    while $cur != 0 { @stack.push($cur); $cur = @left[$cur]; }
    $cur = @stack.pop;
    $c = ($c + @key[$cur] * ($idx % 13)) % 1000003;
    $idx++; $cur = @right[$cur];
}
my $end = now * 1000;
say "Result: {@height[$root]}_{$c}";
say "Time: " ~ ($end - $start).Int ~ "ms";
