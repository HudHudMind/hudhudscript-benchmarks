# Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
# Raku native Int. D=600. Golden: 2668_6766940513

my $D = 600;
my $GUARD = 5;
my $SCALE = $D + 10;

sub arctan-inv(Int $x) {
    my $res = 0;
    my $term = 10 ** $SCALE div $x;
    my $x2 = $x * $x;
    my $sign = 1;
    my $k = 0;
    loop {
        my $divisor = 2 * $k + 1;
        my $t_k = $term div $divisor;
        last if $t_k == 0;
        if $sign > 0 { $res += $t_k } else { $res -= $t_k }
        $sign = -$sign;
        $term div= $x2;
        $k++;
    }
    return $res;
}

my $start = (now * 1000).Int;

my $a5 = arctan-inv(5);
my $a239 = arctan-inv(239);
my $pi = 16 * $a5 - 4 * $a239;

my $s = ~$pi;
$s = $s.fmt("%0" ~ ($D + 10) ~ "d") if $s.chars < $D + 10;
$s = $s.substr(0, $D);

my $ds = [+] $s.comb.map: *.Int;
my $lt = $s.substr(*-10);

my $end = (now * 1000).Int;
say "Result: {$ds}_{$lt}";
say "Time: {$end - $start}ms";
