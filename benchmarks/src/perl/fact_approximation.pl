use Time::HiRes qw(time);
my $start = time * 1000;
my $res = 1.0;
for my $i (2..10000) { $res *= $i; }
my $end = time * 1000;
print "Result: $res
";
printf "Time: %.0fms
", $end - $start;