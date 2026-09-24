use Time::HiRes qw(time);
sub ack {
    my ($m, $n) = @_;
    return $n + 1 if $m == 0;
    return ack($m - 1, 1) if $n == 0;
    return ack($m - 1, ack($m, $n - 1));
}
my $start = time();
my $result = ack(3, 6);
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $result
";
printf "Time: %.0fms
", $ms;
