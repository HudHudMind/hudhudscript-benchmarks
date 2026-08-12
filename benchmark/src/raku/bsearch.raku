my $N = 100000; my $Q = 10000;
my @arr; for ^$N { @arr.push(2 * $_) }
my $found = 0; my $start = now * 1000;
for ^$Q {
    my $target = 20 * $_;
    my ($left, $right) = (0, $N - 1);
    while $left <= $right {
        my $mid = ($left + $right) div 2;
        if @arr[$mid] == $target { $found++; last }
        elsif @arr[$mid] < $target { $left = $mid + 1 }
        else { $right = $mid - 1 }
    }
}
my $end = now * 1000;
say "Result: $found";
say "Time: " ~ ($end - $start).Int ~ "ms";
