use Time::HiRes qw(time);
sub fib {
    my ($n) = @_;
    return $n + 0.0 if $n <= 1;
    my $a = 0.0; my $b = 1.0;
    for my $i (2..$n) {
        my $temp = $a + $b;
        $a = $b;
        $b = $temp;
    }
    return $b;
}
my $start = time * 1000;
my $s = 0.0;
for (1..10000) { $s += fib(1000); }
my $end = time * 1000;
print "Sum: $s
";
printf "Time: %.0fms
", $end - $start;