use Time::HiRes qw(time);
my %memo;
sub fib_memo {
    my ($n) = @_;
    return $n + 0.0 if $n <= 1;
    return $memo{$n} if exists $memo{$n};
    $memo{$n} = fib_memo($n - 1) + fib_memo($n - 2);
    return $memo{$n};
}
my $start = time * 1000;
my $sum = 0.0;
for (1..10000) {
    %memo = ();
    $sum += fib_memo(500);
}
my $end = time * 1000;
print "Sum: $sum
";
printf "Time: %.0fms
", $end - $start;