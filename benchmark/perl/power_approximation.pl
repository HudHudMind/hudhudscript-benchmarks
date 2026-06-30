use Time::HiRes qw(time);
sub power {
    my ($base, $exp) = @_;
    my $res = 1.0;
    for (1..$exp) { $res *= $base; }
    return $res;
}
my $start = time * 1000;
my $sum = 0.0;
for (1..10000) { $sum += power(2.0, 1000); }
my $end = time * 1000;
print "Sum: $sum
";
printf "Time: %.0fms
", $end - $start;