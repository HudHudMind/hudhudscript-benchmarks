my $n = 10000;
my @prime = True xx ($n + 1); @prime[0] = @prime[1] = False;
my $start = now * 1000;
for 2..$n.sqrt.Int -> $i {
    if @prime[$i] {
        my $j = $i * $i;
        while $j <= $n { @prime[$j] = False; $j += $i }
    }
}
my $cnt = 0; $cnt++ if @prime[$_] for 2..$n;
my $end = now * 1000;
say "Result: $cnt";
say "Time: " ~ ($end - $start).Int ~ "ms";
