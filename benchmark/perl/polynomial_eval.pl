use Time::HiRes qw(time);
my @coeffs = 1..1001;
sub horner {
    my ($coeffs, $x) = @_;
    my $result = $coeffs->[1000];
    for (my $i = 999; $i >= 0; $i--) {
        $result = $result * $x + $coeffs->[$i];
    }
    return $result;
}
my $start = time();
my $sum = 0;
for (1..100000) {
    $sum += horner(\@coeffs, 1.5);
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Sum: $sum
";
printf "Time: %.0fms
", $ms;
