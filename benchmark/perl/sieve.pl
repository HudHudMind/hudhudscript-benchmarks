use Time::HiRes qw(time);
my $limit = 10000;
my @sieve = (1) x ($limit + 1);
$sieve[0] = 0; $sieve[1] = 0;
my $start = time();
for my $p (2..int(sqrt($limit))) {
    if ($sieve[$p]) {
        for (my $m = $p * $p; $m <= $limit; $m += $p) {
            $sieve[$m] = 0;
        }
    }
}
my $count = 0;
for my $i (2..$limit) {
    $count++ if $sieve[$i];
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Primes up to 10000: $count
";
printf "Time: %.0fms
", $ms;
