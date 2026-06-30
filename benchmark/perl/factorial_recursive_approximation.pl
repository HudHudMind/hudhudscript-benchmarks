use Time::HiRes qw(time);
sub fact {
    my ($n) = @_;
    return 1.0 if $n <= 1;
    return $n * fact($n - 1);
}
my $start = time * 1000;
my $res = fact(150);
my $end = time * 1000;
print "fact(150) = $res
";
printf "Time: %.0fms
", $end - $start;