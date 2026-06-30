use Time::HiRes qw(time);
my $start = time();
my $s = 0;
for my $i (1..1000000) { $s += $i * $i; }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Sum: $s
";
printf "Time: %.0fms
", $ms;
