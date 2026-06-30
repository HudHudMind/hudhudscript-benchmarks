my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub eval_A(int $i, int $j) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    return 1e0 / ((($i + $j) * ($i + $j + 1) / 2) + $i + 1);
}

sub eval_A_times_u(@u, @v, int $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    loop ($i = 0; $i < $n; $i = $i + 1) {
        @v[$i] = 0e0;
        loop ($j = 0; $j < $n; $j = $j + 1) {
            @v[$i] = @v[$i] + eval_A($i, $j) * @u[$j];
        }
    }
}

sub eval_At_times_u(@u, @v, int $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    loop ($i = 0; $i < $n; $i = $i + 1) {
        @v[$i] = 0e0;
        loop ($j = 0; $j < $n; $j = $j + 1) {
            @v[$i] = @v[$i] + eval_A($j, $i) * @u[$j];
        }
    }
}

sub eval_AtA_times_u(@u, @v, @w, int $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    eval_A_times_u(@u, @w, $n);
    eval_At_times_u(@w, @v, $n);
}

my $start_time = now;
my int $n = 150;
my num @u = 1e0 xx $n;
my num @v = 0e0 xx $n;
my num @w = 0e0 xx $n;

loop ($i = 0; $i < 10; $i = $i + 1) {
    eval_AtA_times_u(@u, @v, @w, $n);
    eval_AtA_times_u(@v, @u, @w, $n);
}

my num $vBv = 0e0;
my num $vv = 0e0;
loop ($i = 0; $i < $n; $i = $i + 1) {
    $vBv = $vBv + @u[$i] * @v[$i];
    $vv = $vv + @v[$i] * @v[$i];
}

my num $res = sqrt($vBv / $vv);
my $end_time = now;

printf("Result: %.9f\n", $res);
printf("Time: %dms\n", (($end_time - $start_time) * 1000).Int);
