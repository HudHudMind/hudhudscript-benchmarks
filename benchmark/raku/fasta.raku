my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b; my int $c;
my $start_time = now;

my int $seed = 42;
sub rand_val(num $max_val) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    $seed = ($seed * 3877 + 29573) % 139968;
    return $max_val * $seed / 139968e0;
}

my @iub = (
    ['a', 0.27e0], ['c', 0.12e0], ['g', 0.12e0], ['t', 0.27e0],
    ['B', 0.02e0], ['D', 0.02e0], ['H', 0.02e0], ['K', 0.02e0],
    ['M', 0.02e0], ['N', 0.02e0], ['R', 0.02e0], ['S', 0.02e0],
    ['V', 0.02e0], ['W', 0.02e0], ['Y', 0.02e0]
);

my num $cp = 0e0;
loop ($i = 0; $i < @iub.elems; $i = $i + 1) {
    $cp = $cp + @iub[$i][1];
    @iub[$i][1] = $cp;
}

my int $res = 0;
my int $n = 50000;

my int $total = $n * 2;
while $total > 0 {
    my int $chunk = $total < 60 ?? $total !! 60;
    $res = $res + $chunk;
    $total = $total - $chunk;
}

$total = $n * 3;
while $total > 0 {
    my int $chunk = $total < 60 ?? $total !! 60;
    loop ($c = 0; $c < $chunk; $c = $c + 1) {
        my num $r = rand_val(1e0);
        loop ($j = 0; $j < @iub.elems; $j = $j + 1) {
            if $r < @iub[$j][1] {
                $res = $res + 1;
                last;
            }
        }
    }
    $total = $total - $chunk;
}

my $end_time = now;
say "Result: $res";
printf("Time: %dms\n", (($end_time - $start_time) * 1000).Int);
