use Time::HiRes qw(time);
my (@weights, @values);
for my $i (0..49) {
    $weights[$i] = ($i * 7 + 3) % 20 + 1;
    $values[$i] = ($i * 13 + 5) % 50 + 10;
}
my ($capacity, $n) = (100, 50);
my $start = time();
my @dp;
for my $i (0..$n) {
    for my $w (0..$capacity) {
        $dp[$i][$w] = 0;
    }
}
for my $i (1..$n) {
    for my $w (0..$capacity) {
        if ($weights[$i - 1] <= $w) {
            my $incl = $values[$i - 1] + $dp[$i - 1][$w - $weights[$i - 1]];
            $dp[$i][$w] = $incl > $dp[$i - 1][$w] ? $incl : $dp[$i - 1][$w];
        } else {
            $dp[$i][$w] = $dp[$i - 1][$w];
        }
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Max: $dp[$n][$capacity]
";
printf "Time: %.0fms
", $ms;
