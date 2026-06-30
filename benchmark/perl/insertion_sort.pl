use Time::HiRes qw(time);
my $n = 1000;
my @arr = reverse 1..$n;
my $start = time();
for my $j (1..$n-1) {
    my $key = $arr[$j]; my $k = $j - 1;
    while ($k >= 0 && $arr[$k] > $key) { $arr[$k + 1] = $arr[$k]; $k--; }
    $arr[$k + 1] = $key;
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "First: $arr[0]
";
print "Last: $arr[$n-1]
";
printf "Time: %.0fms
", $ms;
