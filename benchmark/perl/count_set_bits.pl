use Time::HiRes qw(time);
my $start = time();
my $total = 0;
for my $n (1..100000) {
    my $x = $n;
    while ($x > 0) { $total++ if $x % 2 == 1; $x = int($x / 2); }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Total: $total
";
printf "Time: %.0fms
", $ms;
