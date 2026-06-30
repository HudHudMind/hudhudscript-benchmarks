use Time::HiRes qw(time);
my (@a, @b);
for my $i (0..499999) { $a[$i] = $i + 1; $b[$i] = $i + 2; }
my $start = time();
my $s = 0;
for my $i (0..499999) { $s += $a[$i] * $b[$i]; }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Dot: $s
";
printf "Time: %.0fms
", $ms;
