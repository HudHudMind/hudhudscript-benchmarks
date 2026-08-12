my $total = 0e0; my $start = now * 1000;
for 1..10000 {
    my $x = 1e0 * $_;
    my $guess = $x / 2e0;
    for ^20 { $guess = ($guess + $x / $guess) / 2e0 }
    $total += $guess;
}
my $end = now * 1000;
say "Result: $total";
say "Time: " ~ ($end - $start).Int ~ "ms";
