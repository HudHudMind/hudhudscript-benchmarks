use Time::HiRes qw(time);
my @arr = 0..9999;
my $start = time();
my $sum = 0;
for my $i (0..9999) { $sum += $arr[$i]; }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Sum: $sum
";
printf "Time: %.0fms
", $ms;
