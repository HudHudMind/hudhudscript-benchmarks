my $n = 1000; my @coeff; for 1..$n+1 { @coeff.push($_ * 1e0) }
my $R = 100000; my $x = 1.5e0; my $total = 0e0; my $start = now * 1000;
for ^$R {
    my $y = @coeff[$n];
    loop (my $i = $n - 1; $i >= 0; $i = $i - 1) { $y = $y * $x + @coeff[$i] }
    $total += $y;
}
my $end = now * 1000;
say "Result: $total";
say "Time: " ~ ($end - $start).Int ~ "ms";
