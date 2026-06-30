use Time::HiRes qw(time);
my $size = 300;
my (@m, @t);
for my $i (0..$size-1) {
    for my $j (0..$size-1) { $m[$i][$j] = $i + $j; $t[$i][$j] = 0; }
}
my $start = time();
for my $i (0..$size-1) {
    for my $j (0..$size-1) { $t[$j][$i] = $m[$i][$j]; }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "T[0][0]: $t[0][0]
";
print "T[299][299]: $t[299][299]
";
printf "Time: %.0fms
", $ms;
