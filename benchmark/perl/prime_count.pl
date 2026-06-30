use Time::HiRes qw(time);
sub is_prime {
    my $n = shift;
    return 0 if $n < 2;
    return 1 if $n == 2;
    return 0 if $n % 2 == 0;
    for (my $i = 3; $i * $i <= $n; $i += 2) {
        return 0 if $n % $i == 0;
    }
    return 1;
}
my $start = time();
my $count = 0;
for my $n (2..100000) { $count++ if is_prime($n); }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Primes: $count
";
printf "Time: %.0fms
", $ms;
