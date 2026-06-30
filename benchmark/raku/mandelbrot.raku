my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub mandelbrot($size) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    my $sum-iters = 0;
    loop (my $y = 0; $y < $size; $y++) {
        loop (my $x = 0; $x < $size; $x++) {
            my num $zr = 0e0;
            my num $zi = 0e0;
            my num $cr = (2e0 * $x / $size) - 1.5e0;
            my num $ci = (2e0 * $y / $size) - 1.0e0;
            my $escape = 0;
            loop (my $i = 0; $i < 50; $i++) {
                my num $tr = $zr * $zr - $zi * $zi + $cr;
                my num $ti = 2e0 * $zr * $zi + $ci;
                $zr = $tr;
                $zi = $ti;
                if $zr * $zr + $zi * $zi > 4e0 {
                    $escape = 1;
                    last;
                }
            }
            $sum-iters += $escape;
        }
    }
    return $sum-iters;
}

my $start = now * 1000;
my $res = mandelbrot(500);
my $end = now * 1000;

put "Sum: $res";
put "Time: ", ($end - $start).Int, "ms";
