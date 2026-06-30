my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my num $PI = 3.141592653589793e0;
my num $SOLAR_MASS = 4e0 * $PI * $PI;
my num $DAYS_PER_YEAR = 365.24e0;

sub advance(@bodies, num $dt) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    my int $n = @bodies.elems;
    loop ($i = 0; $i < $n; $i = $i + 1) {
        loop ($j = $i + 1; $j < $n; $j = $j + 1) {
            my num $dx = @bodies[$i][0] - @bodies[$j][0];
            my num $dy = @bodies[$i][1] - @bodies[$j][1];
            my num $dz = @bodies[$i][2] - @bodies[$j][2];
            
            my num $dsq = $dx*$dx + $dy*$dy + $dz*$dz;
            my num $mag = $dt / ($dsq * sqrt($dsq));
            
            @bodies[$i][3] = @bodies[$i][3] - $dx * @bodies[$j][6] * $mag;
            @bodies[$i][4] = @bodies[$i][4] - $dy * @bodies[$j][6] * $mag;
            @bodies[$i][5] = @bodies[$i][5] - $dz * @bodies[$j][6] * $mag;
            
            @bodies[$j][3] = @bodies[$j][3] + $dx * @bodies[$i][6] * $mag;
            @bodies[$j][4] = @bodies[$j][4] + $dy * @bodies[$i][6] * $mag;
            @bodies[$j][5] = @bodies[$j][5] + $dz * @bodies[$i][6] * $mag;
        }
    }
    loop ($i = 0; $i < $n; $i = $i + 1) {
        @bodies[$i][0] = @bodies[$i][0] + $dt * @bodies[$i][3];
        @bodies[$i][1] = @bodies[$i][1] + $dt * @bodies[$i][4];
        @bodies[$i][2] = @bodies[$i][2] + $dt * @bodies[$i][5];
    }
}

sub energy(@bodies) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    my num $e = 0e0;
    my int $n = @bodies.elems;
    loop ($i = 0; $i < $n; $i = $i + 1) {
        $e = $e + 0.5e0 * @bodies[$i][6] * (@bodies[$i][3]*@bodies[$i][3] + @bodies[$i][4]*@bodies[$i][4] + @bodies[$i][5]*@bodies[$i][5]);
        loop ($j = $i + 1; $j < $n; $j = $j + 1) {
            my num $dx = @bodies[$i][0] - @bodies[$j][0];
            my num $dy = @bodies[$i][1] - @bodies[$j][1];
            my num $dz = @bodies[$i][2] - @bodies[$j][2];
            $e = $e - (@bodies[$i][6] * @bodies[$j][6]) / sqrt($dx*$dx + $dy*$dy + $dz*$dz);
        }
    }
    return $e;
}

my @bodies = (
    [0e0, 0e0, 0e0, 0e0, 0e0, 0e0, $SOLAR_MASS],
    [4.84143144246472090e0, -1.16032004402742839e0, -0.103622044471123109e0,
     1.66007664274403694e-03 * $DAYS_PER_YEAR, 7.69901118419740425e-03 * $DAYS_PER_YEAR, -6.90460016972063023e-05 * $DAYS_PER_YEAR,
     9.54791938424326609e-04 * $SOLAR_MASS],
    [8.34336671824457987e0, 4.12479856412430479e0, -0.403523417114321381e0,
     -2.76742510726862411e-03 * $DAYS_PER_YEAR, 4.99852801234917238e-03 * $DAYS_PER_YEAR, 2.30417297573763929e-05 * $DAYS_PER_YEAR,
     2.85885980666130812e-04 * $SOLAR_MASS],
    [12.8943695621391310e0, -15.1111514016986312e0, -0.223307578892655734e0,
     2.96460137564761618e-03 * $DAYS_PER_YEAR, 2.37847173959480950e-03 * $DAYS_PER_YEAR, -2.96589568540237556e-05 * $DAYS_PER_YEAR,
     4.36624404335156298e-05 * $SOLAR_MASS],
    [15.3796971148509165e0, -25.9193146099879641e0, 0.179258772950371181e0,
     2.68067772490389322e-03 * $DAYS_PER_YEAR, 1.62824170038242295e-03 * $DAYS_PER_YEAR, -9.51592254519715870e-05 * $DAYS_PER_YEAR,
     5.15138902046611451e-05 * $SOLAR_MASS]
);

my num $px = 0e0;
my num $py = 0e0;
my num $pz = 0e0;
for @bodies -> @b {
    $px = $px + @b[3] * @b[6];
    $py = $py + @b[4] * @b[6];
    $pz = $pz + @b[5] * @b[6];
}
@bodies[0][3] = -$px / $SOLAR_MASS;
@bodies[0][4] = -$py / $SOLAR_MASS;
@bodies[0][5] = -$pz / $SOLAR_MASS;

my $start_time = now;
my num $e1 = energy(@bodies);
loop ($i = 0; $i < 10000; $i = $i + 1) {
    advance(@bodies, 0.01e0);
}
my num $e2 = energy(@bodies);
my $end_time = now;

printf("Result: %.9f_%.9f\n", $e1, $e2);
printf("Time: %dms\n", (($end_time - $start_time) * 1000).Int);
