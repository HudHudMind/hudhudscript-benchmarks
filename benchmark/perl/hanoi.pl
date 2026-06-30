use Time::HiRes qw(time);
sub hanoi {
    my $n = shift;
    return 1 if $n == 1;
    return hanoi($n - 1) + 1 + hanoi($n - 1);
}
my $start = time();
my $moves = hanoi(20);
my $end = time();
my $ms = ($end - $start) * 1000;
print "Moves: $moves
";
printf "Time: %.0fms
", $ms;
