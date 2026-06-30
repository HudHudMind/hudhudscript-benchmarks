use Time::HiRes qw(time);
my $n = 500;
my @arr = reverse 1..$n;
my $start = time();
for my $k (0..$n-1) {
    for my $j (0..$n-2) {
        if ($arr[$j] > $arr[$j + 1]) {
            @arr[$j, $j+1] = @arr[$j+1, $j];
        }
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "First: $arr[0]
";
print "Last: $arr[$n-1]
";
printf "Time: %.0fms
", $ms;
