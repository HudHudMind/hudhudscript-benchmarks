my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub fannkuch(int $n) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    my int @p = 0 .. $n - 1;
    my int @q = 0 .. $n - 1;
    my int @s = 0 .. $n - 1;
    my int $sign = 1;
    my int $maxflips = 0;
    my int $sumflips = 0;

    loop {
        my int $q1 = @p[0];
        if $q1 != 0 {
            loop ($i = 1; $i < $n; $i = $i + 1) { @q[$i] = @p[$i]; }
            my int $flips = 1;
            loop {
                my int $qq = @q[$q1];
                last if $qq == 0;
                @q[$q1] = $q1;
                if $q1 >= 3 {
                    my int $i = 1;
                    my int $j = $q1 - 1;
                    while $i < $j {
                        my int $t = @q[$i];
                        @q[$i] = @q[$j];
                        @q[$j] = $t;
                        $i = $i + 1;
                        $j = $j - 1;
                    }
                }
                $q1 = $qq;
                $flips = $flips + 1;
            }
            if $flips > $maxflips { $maxflips = $flips; }
            $sumflips = $sumflips + $sign * $flips;
        }

        if $sign == 1 {
            my int $t = @p[1];
            @p[1] = @p[0];
            @p[0] = $t;
            $sign = -1;
        } else {
            my int $t = @p[1];
            @p[1] = @p[2];
            @p[2] = $t;
            $sign = 1;
            my int $k = 2;
            while $k < $n {
                @s[$k] = @s[$k] - 1;
                last if @s[$k] != 0;
                @s[$k] = $k;
                my int $t0 = @p[0];
                loop ($m = 0; $m <= $k; $m = $m + 1) {
                    @p[$m] = $m < $k ?? @p[$m + 1] !! $t0;
                }
                $k = $k + 1;
            }
            last if $k == $n;
        }
    }
    return "$sumflips" ~ "_" ~ "$maxflips";
}

my $start_time = now;
my $res = fannkuch(9);
my $end_time = now;

say "Result: $res";
printf("Time: %dms\n", (($end_time - $start_time) * 1000).Int);
