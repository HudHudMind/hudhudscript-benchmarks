use Time::HiRes qw(time);
sub sqrt_newton {
    my $n = shift; return 0 if $n == 0;
    my $x = $n / 2;
    for (1..20) { $x = ($x + $n / $x) / 2; }
    return $x;
}
my $start = time();
my $sum = 0;
for my $i (1..10000) { $sum += sqrt_newton($i); }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Sum: $sum
";
printf "Time: %.0fms
", $ms;
