use Time::HiRes qw(time);
sub gcd {
    my ($a, $b) = @_;
    while ($b != 0) {
        my $t = $b; $b = $a % $b; $a = $t;
    }
    return $a;
}
my $start = time();
my $result = 0;
for my $i (1..10000) {
    $result = gcd($i * 12345, $i * 6789 + 1);
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $result
";
printf "Time: %.0fms
", $ms;
