use Time::HiRes qw(time);
my $n = 200; my @A;
for my $i (0..$n-1) {
    for my $j (0..$n-1) {
        $A[$i][$j] = (($i*31 + $j*17) % 100 + 1) + ($i == $j ? 1000 : 0);
    }
}
my $start = time();
for my $k (0..$n-1) {
    for my $i ($k+1..$n-1) {
        my $f = $A[$i][$k] / $A[$k][$k];
        for my $j (0..$n-1) { $A[$i][$j] -= $f * $A[$k][$j]; }
        $A[$i][$k] = $f;
    }
}
my $s = 0;
for my $i (0..$n-1) { $s += $A[$i][$i]; }
my $r = int($s / $n * 1000 + 0.5);
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $r\n";
printf "Time: %.0fms\n", $ms;
