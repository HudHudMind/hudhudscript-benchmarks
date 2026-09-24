sub power($base, $exp) {
    my $res = 1;
    for ^$exp { $res *= $base }
    $res
}
my $R = 10000;
my $sum = 0;
my $start = now * 1000;
for ^$R { $sum += power(2, 1000) }
my $end = now * 1000;
say "Result: " ~ $sum;
say "Time: " ~ ($end - $start).Int ~ "ms";
