sub gcd($a, $b) {
    my ($x, $y) = ($a, $b);
    while $y != 0 { ($x, $y) = ($y, $x % $y) }
    $x
}
my $start = now * 1000;
my $result = 0;
for 1..10000 -> $i { $result = gcd($i * 12345, $i * 6789 + 1) }
my $end = now * 1000;
say "Result: " ~ $result;
say "Time: " ~ ($end - $start).Int ~ "ms";
