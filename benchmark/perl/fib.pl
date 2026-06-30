use Time::HiRes qw(time);
sub fib {
    my $n = shift;
    return $n if $n <= 1;
    return fib($n - 1) + fib($n - 2);
}
my $start = time();
my $result = fib(30);
my $end = time();
my $ms = ($end - $start) * 1000;
print "fib(30) = $result
";
printf "Time: %.0fms
", $ms;
