use Time::HiRes qw(time);
sub mod_exp {
    my ($base, $exp, $mod) = @_;
    my $result = 1; $base %= $mod;
    while ($exp > 0) {
        $result = ($result * $base) % $mod if $exp % 2 == 1;
        $exp = int($exp / 2); $base = ($base * $base) % $mod;
    }
    return $result;
}
my $start = time();
my $sum = 0;
for my $i (1..10000) { $sum += mod_exp(3, 1000, 1000000007); }
my $end = time();
my $ms = ($end - $start) * 1000;
print "Sum: $sum
";
printf "Time: %.0fms
", $ms;
