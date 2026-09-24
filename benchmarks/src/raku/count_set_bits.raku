my $n = 100000; my $total = 0; my $start = now * 1000;
for 1..$n {
    my $x = $_;
    while $x > 0 { $total += $x % 2; $x div= 2 }
}
my $end = now * 1000;
say "Result: $total";
say "Time: " ~ ($end - $start).Int ~ "ms";
