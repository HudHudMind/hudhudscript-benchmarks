use Time::HiRes qw(time);
my $n = 100;
my @adj;
for my $i (0..$n-1) {
    for my $j (0..$n-1) {
        $adj[$i][$j] = (($i * 3 + $j * 7) % 11 == 0 && $i != $j) ? 1 : 0;
    }
}
my $start = time();
my @visited = (0) x $n;
my @stack = (0);
my $count = 0;
while (@stack) {
    my $node = pop @stack;
    if (!$visited[$node]) {
        $visited[$node] = 1;
        $count++;
        for my $neighbor (reverse 0..$n-1) {
            if ($adj[$node][$neighbor] == 1 && !$visited[$neighbor]) {
                push @stack, $neighbor;
            }
        }
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Visited: $count
";
printf "Time: %.0fms
", $ms;
