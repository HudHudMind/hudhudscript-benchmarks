use Time::HiRes qw(time);
my $inside = 0;
my $total = 500000;
my $seed = 12345;
sub next_random {
    $seed = ($seed * 16807) % 2147483647;
    return $seed / 2147483647.0;
}
my $start = time();
for my $i (1..$total) {
    my $x = next_random();
    my $y = next_random();
    if ($x * $x + $y * $y <= 1.0) {
        $inside++;
    }
}
my $end = time();
my $pi = 4.0 * $inside / $total;
my $ms = ($end - $start) * 1000;
print "Pi: $pi\n";
printf "Time: %.0fms\n", $ms;
