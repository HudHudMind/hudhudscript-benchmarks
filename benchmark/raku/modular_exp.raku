my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub mod_exp($base is copy, $exp is copy, $mod) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    my $result = 1;
    my $b = $base % $mod;
    while $exp > 0 {
        if $exp % 2 == 1 {
            $result = ($result * $b) % $mod;
        }
        $b = ($b * $b) % $mod;
        $exp = $exp div 2;
    }; return $result;
}; my $start = now * 1000;
my $sum = 0;
for 1..10000 {
    $sum += mod_exp(3, 1000, 1000000007);
}; my $end = now * 1000;
say "Sum: " ~ $sum;
say "Time: " ~ ($end - $start).Int ~ "ms";
