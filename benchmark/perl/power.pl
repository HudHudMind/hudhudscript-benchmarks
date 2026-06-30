use Time::HiRes qw(time);
use constant BASE => 1000000000;

sub add_big {
    my ($a, $b) = @_;
    my $n = @$a > @$b ? @$a : @$b;
    my @result;
    my $carry = 0;
    for (my $i = 0; $i < $n; $i++) {
        my $sum = ($a->[$i] // 0) + ($b->[$i] // 0) + $carry;
        if ($sum >= BASE) {
            $sum -= BASE;
            $carry = 1;
        } else {
            $carry = 0;
        }
        $result[$i] = $sum;
    }
    push @result, $carry if $carry > 0;
    return \@result;
}

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

sub power {
    my ($base, $exp) = @_;
    my $result = [1];
    for (my $i = 0; $i < $exp; $i++) {
        $result = mul_small($result, $base);
    }
    return $result;
}

my $start = time * 1000;
my $sum = [0];
for (1..10000) {
    $sum = add_big($sum, power(2, 1000));
}
my $end = time * 1000;
print "Sum: " . big_to_string($sum) . "\n";
printf "Time: %.0fms\n", $end - $start;
