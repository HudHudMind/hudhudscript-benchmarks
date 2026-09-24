use Time::HiRes qw(time);
my $n = 1000;
my @arr = reverse 1..$n;
my $start = time();
for (my $width = 1; $width < $n; $width *= 2) {
    for (my $left = 0; $left < $n; $left += 2 * $width) {
        my $mid = $left + $width - 1;
        if ($mid < $n - 1) {
            my $right = $left + 2 * $width - 1;
            $right = $n - 1 if $right >= $n;
            my $n1 = $mid - $left + 1;
            my $n2 = $right - $mid;
            my @L = @arr[$left..$mid];
            my @R = @arr[$mid+1..$right];
            my ($i, $j, $k) = (0, 0, $left);
            while ($i < $n1 && $j < $n2) {
                if ($L[$i] <= $R[$j]) { $arr[$k] = $L[$i]; $i++; }
                else { $arr[$k] = $R[$j]; $j++; }
                $k++;
            }
            while ($i < $n1) { $arr[$k] = $L[$i]; $i++; $k++; }
            while ($j < $n2) { $arr[$k] = $R[$j]; $j++; $k++; }
        }
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $arr[0]/$arr[$n-1]\n";
printf "Time: %.0fms
", $ms;
