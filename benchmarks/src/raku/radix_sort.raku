my $n = 200000;
my $seed = 12345;
sub ri($m) {
    $seed = ($seed * 16807) % 2147483647;
    $seed % $m;
}

my Int @arr;
for ^$n { @arr.push(ri(1000000)); }

my $start = now * 1000;

my @buckets = 0 xx 10;
my Int @output;
for ^$n { @output.push(0); }

for ^6 -> $p {
    @buckets = 0 xx 10;
    my $div = 10 ** $p;
    for ^$n -> $i {
        my $d = (@arr[$i] div $div) % 10;
        @buckets[$d]++;
    }
    for 1..9 -> $i { @buckets[$i] += @buckets[$i - 1]; }
    for $n - 1 ... 0 -> $i {
        my $d = (@arr[$i] div $div) % 10;
        @buckets[$d]--;
        @output[@buckets[$d]] = @arr[$i];
    }
    my @tmp = @arr;
    @arr = @output;
    @output = @tmp;
}

my $c = 0;
for ^$n -> $i { $c = ($c + @arr[$i] * ($i % 7)) % 1000003; }

my $end = now * 1000;
say "Result: {@arr[0]}/{@arr[$n-1]}_{$c}";
say "Time: " ~ ($end - $start).Int ~ "ms";
