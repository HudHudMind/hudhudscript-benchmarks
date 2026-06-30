use Time::HiRes qw(time);
my @arr = 1..1000000;
my $n = 1000000;
my $start = time();
my $sum = 0;
for my $i (0..$n-1) { $sum += $arr[$i]; }
my $mean = $sum / $n;
my $sq = 0;
for my $i (0..$n-1) { my $d = $arr[$i] - $mean; $sq += $d * $d; }
my $var = $sq / $n;
my $end = time();
my $ms = ($end - $start) * 1000;
print "Mean: $mean
";
print "Variance: $var
";
printf "Time: %.0fms
", $ms;
