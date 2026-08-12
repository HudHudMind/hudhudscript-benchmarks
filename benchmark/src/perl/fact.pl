use Time::HiRes qw(time);
use constant BASE => 1000000000;

sub mul_small {
    my ($a, $n) = @_;
    my @result;
    my $carry = 0;
    for (my $i = 0; $i < @$a; $i++) {
        my $prod = $a->[$i] * $n + $carry;
        $result[$i] = $prod % BASE;
        $carry = int($prod / BASE);
    }
    while ($carry > 0) {
        push @result, $carry % BASE;
        $carry = int($carry / BASE);
    }
    return \@result;
}

sub big_to_string {
    my ($a) = @_;
    my $result = "$a->[-1]";
    for (my $i = @$a - 2; $i >= 0; $i--) {
        $result .= sprintf("%09d", $a->[$i]);
    }
    return $result;
}

my $start = time * 1000;
my $result = [1];
for my $i (2..10000) {
    $result = mul_small($result, $i);
}
my $end = time * 1000;
print "Result: " . big_to_string($result) . "\n";
printf "Time: %.0fms\n", $end - $start;
