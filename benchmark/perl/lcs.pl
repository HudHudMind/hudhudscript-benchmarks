use Time::HiRes qw(time);
my $s1 = "abcdefghij" x 10;
my $s2 = "acegikmoqs" x 10;
my $start = time();
my ($m, $n) = (length($s1), length($s2));
my @dp;
for my $i (0..$m) { for my $j (0..$n) { $dp[$i][$j] = 0; } }
for my $i (1..$m) {
    for my $j (1..$n) {
        if (substr($s1,$i-1,1) eq substr($s2,$j-1,1)) {
            $dp[$i][$j] = $dp[$i-1][$j-1] + 1;
        } else {
            $dp[$i][$j] = $dp[$i-1][$j] > $dp[$i][$j-1] ? $dp[$i-1][$j] : $dp[$i][$j-1];
        }
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "LCS: $dp[$m][$n]
";
printf "Time: %.0fms
", $ms;
