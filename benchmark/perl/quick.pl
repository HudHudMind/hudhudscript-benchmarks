use Time::HiRes qw(time);
my $n = 1000;
my @arr = reverse 1..$n;
my $start = time();
my @stack = (0, $n - 1);
while (@stack) {
    my $high = pop @stack;
    my $low = pop @stack;
    if ($low < $high) {
        my $pivot = $arr[$high];
        my $pi = $low - 1;
        for my $j ($low..$high-1) {
            if ($arr[$j] <= $pivot) { $pi++; @arr[$pi, $j] = @arr[$j, $pi]; }
        }
        $pi++; @arr[$pi, $high] = @arr[$high, $pi];
        if ($pi - 1 > $low) { push @stack, $low, $pi - 1; }
        if ($pi + 1 < $high) { push @stack, $pi + 1, $high; }
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
