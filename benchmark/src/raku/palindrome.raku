my $N = 50000;
my $s = "a" x $N;
my $R = 1000;
my $ok = True;
my $start = now * 1000;
for ^$R {
    my $left = 0;
    my $right = $N - 1;
    while $left < $right {
        if $s.substr($left, 1) ne $s.substr($right, 1) { $ok = False; last; }
        $left++; $right--;
    }
}
my $end = now * 1000;
say "Result: " ~ ($ok ?? "true" !! "false");
say "Time: " ~ ($end - $start).Int ~ "ms";
