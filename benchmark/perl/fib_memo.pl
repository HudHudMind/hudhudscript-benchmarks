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

sub big_to_string {
    my ($a) = @_;
    my $result = "$a->[-1]";
    for (my $i = @$a - 2; $i >= 0; $i--) {
        $result .= sprintf("%09d", $a->[$i]);
    }
    return $result;
}

my %memo;

sub fib_memo {
    my ($n) = @_;
    return $memo{$n} if exists $memo{$n};
    $memo{$n} = add_big(fib_memo($n - 1), fib_memo($n - 2));
    return $memo{$n};
}

my $start = time * 1000;
my $sum = [0];
for (1..10000) {
    %memo = (0 => [0], 1 => [1]);
    $sum = add_big($sum, fib_memo(500));
}
my $end = time * 1000;
print "Sum: " . big_to_string($sum) . "\n";
printf "Time: %.0fms\n", $end - $start;
