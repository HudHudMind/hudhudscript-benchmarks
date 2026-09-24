my $inside = 0;
my $total = 500000;
my $seed = 12345;
sub next_random() {
    $seed = ($seed * 16807) % 2147483647;
    return $seed / 2147483647e0;
}; my $start = now * 1000;
for 1..$total {
    my $x = next_random();
    my $y = next_random();
    $inside++ if $x * $x + $y * $y <= 1e0;
}; my $end = now * 1000;
my $pi = 4e0 * $inside / $total;
say "Result: " ~ $pi;
say "Time: " ~ ($end - $start).Int ~ "ms";
