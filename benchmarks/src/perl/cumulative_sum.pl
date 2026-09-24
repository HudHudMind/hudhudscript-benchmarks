use Time::HiRes qw(time);
my @arr = 1..100000;
my $start = time();
my @cum; my $sum = 0;
for my $i (0..99999) { $sum += $arr[$i]; push @cum, $sum; }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $cum[99999]\n";
printf "Time: %.0fms\n", $ms;
