use Time::HiRes qw(time);
my @arr = 1..100000;
my $start = time();
my $sum = 0;
for my $i (0..99999) { $sum += $arr[$i]; $arr[$i] = $sum; }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Last: $arr[99999]
";
printf "Time: %.0fms
", $ms;
