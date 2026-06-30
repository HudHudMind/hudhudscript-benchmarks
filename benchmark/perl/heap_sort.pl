use Time::HiRes qw(time);
my $n = 1000;
my @arr = reverse 1..$n;
my $start = time();
for (my $i = int($n/2) - 1; $i >= 0; $i--) {
    my $idx = $i;
    while (1) {
        my $largest = $idx; my $left = 2*$idx+1; my $right = 2*$idx+2;
        if ($left < $n && $arr[$left] > $arr[$largest]) { $largest = $left; }
        if ($right < $n && $arr[$right] > $arr[$largest]) { $largest = $right; }
        last if $largest == $idx;
        @arr[$idx, $largest] = @arr[$largest, $idx];
        $idx = $largest;
    }
}
for (my $i = $n - 1; $i > 0; $i--) {
    @arr[0, $i] = @arr[$i, 0];
    my $idx = 0; my $size = $i;
    while (1) {
        my $largest = $idx; my $left = 2*$idx+1; my $right = 2*$idx+2;
        if ($left < $size && $arr[$left] > $arr[$largest]) { $largest = $left; }
        if ($right < $size && $arr[$right] > $arr[$largest]) { $largest = $right; }
        last if $largest == $idx;
        @arr[$idx, $largest] = @arr[$largest, $idx];
        $idx = $largest;
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
