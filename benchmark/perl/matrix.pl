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
        my $s = 0;
        for my $k (0..$size-1) { $s += $a[$i][$k] * $b[$k][$j]; }
        $c[$i][$j] = $s;
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result[0][0]: $c[0][0]
";
print "Result[149][149]: $c[149][149]
";
printf "Time: %.0fms
", $ms;
