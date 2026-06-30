use Time::HiRes qw(time);
my $start = time();
my ($max_s, $max_n) = (0, 0);
for my $n (1..10000) {
    my $s = 0; my $c = $n;
    while ($c != 1) {
        if ($c % 2 == 0) { $c = int($c / 2); }
        else { $c = $c * 3 + 1; }
        $s++;
    }
    if ($s > $max_s) { $max_s = $s; $max_n = $n; }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Max steps: $max_s at n=$max_n
";
printf "Time: %.0fms
", $ms;
