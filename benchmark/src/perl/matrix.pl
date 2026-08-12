use Time::HiRes qw(time);
my $size = 150;
my (@a, @b, @c);
for my $i (0..$size-1) {
    for my $j (0..$size-1) {
        $a[$i][$j] = $i + $j;
        $b[$i][$j] = $i - $j;
        $c[$i][$j] = 0;
    }
}
my $start = time();
for my $i (0..$size-1) {
    for my $j (0..$size-1) {
        for my $k (0..$size-1) { $c[$i][$j] += $a[$i][$k] * $b[$k][$j]; }
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $c[0][0]/$c[149][149]\n";
printf "Time: %.0fms
", $ms;
