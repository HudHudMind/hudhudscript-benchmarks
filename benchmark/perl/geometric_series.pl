use Time::HiRes qw(time);
my ($r, $sum, $term) = (0.999, 0, 1);
my $start = time();
for (1..1000000) { $sum += $term; $term *= $r; }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Sum: $sum
";
printf "Time: %.0fms
", $ms;
