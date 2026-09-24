# Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
# Perl Math::BigInt. D=600. Golden: 2668_6766940513
use Math::BigInt;
use Time::HiRes qw(time);

my $D = 600;
my $GUARD = 5;
my $SCALE = $D + 10;

sub arctan_inv {
    my ($x) = @_;
    my $res = Math::BigInt->new(0);
    my $term = Math::BigInt->new(10)->bpow($SCALE)->bdiv($x);
    my $x2 = Math::BigInt->new($x * $x);
    my $sign = 1;
    my $k = 0;
    while (1) {
        my $divisor = Math::BigInt->new(2 * $k + 1);
        my $t_k = $term->copy()->bdiv($divisor);
        last if $t_k->is_zero();
        if ($sign > 0) {
            $res->badd($t_k);
        } else {
            $res->bsub($t_k);
        }
        $sign = -$sign;
        $term->bdiv($x2);
        $k++;
    }
    return $res;
}

my $start = time() * 1000;

my $a5 = arctan_inv(5);
my $a239 = arctan_inv(239);
my $pi = $a5->copy()->bmul(16)->bsub($a239->copy()->bmul(4));

my $s = $pi->bstr();
if (length($s) < $D + 10) {
    $s = ('0' x ($D + 10 - length($s))) . $s;
}
$s = substr($s, 0, $D);

my $ds = 0;
$ds += $_ for split //, $s;
my $lt = substr($s, -10);

my $end = time() * 1000;
print "Result: ${ds}_${lt}\n";
printf "Time: %.0fms\n", $end - $start;
