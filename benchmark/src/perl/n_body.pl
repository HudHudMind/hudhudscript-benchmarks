use strict;
use warnings;
use Time::HiRes qw(time);

my $PI = 3.141592653589793;
my $SOLAR_MASS = 4 * $PI * $PI;
my $DAYS_PER_YEAR = 365.24;

sub advance {
    my ($bodies, $dt) = @_;
    my $n = scalar(@$bodies);
    for my $i (0 .. $n - 1) {
        for my $j ($i + 1 .. $n - 1) {
            my $dx = $bodies->[$i][0] - $bodies->[$j][0];
            my $dy = $bodies->[$i][1] - $bodies->[$j][1];
            my $dz = $bodies->[$i][2] - $bodies->[$j][2];
            
            my $dsq = $dx*$dx + $dy*$dy + $dz*$dz;
            my $mag = $dt / ($dsq * sqrt($dsq));
            
            $bodies->[$i][3] -= $dx * $bodies->[$j][6] * $mag;
            $bodies->[$i][4] -= $dy * $bodies->[$j][6] * $mag;
            $bodies->[$i][5] -= $dz * $bodies->[$j][6] * $mag;
            
            $bodies->[$j][3] += $dx * $bodies->[$i][6] * $mag;
            $bodies->[$j][4] += $dy * $bodies->[$i][6] * $mag;
            $bodies->[$j][5] += $dz * $bodies->[$i][6] * $mag;
        }
    }
    for my $i (0 .. $n - 1) {
        $bodies->[$i][0] += $dt * $bodies->[$i][3];
        $bodies->[$i][1] += $dt * $bodies->[$i][4];
        $bodies->[$i][2] += $dt * $bodies->[$i][5];
    }
}

sub energy {
    my ($bodies) = @_;
    my $e = 0.0;
    my $n = scalar(@$bodies);
    for my $i (0 .. $n - 1) {
        $e += 0.5 * $bodies->[$i][6] * ($bodies->[$i][3]*$bodies->[$i][3] + $bodies->[$i][4]*$bodies->[$i][4] + $bodies->[$i][5]*$bodies->[$i][5]);
        for my $j ($i + 1 .. $n - 1) {
            my $dx = $bodies->[$i][0] - $bodies->[$j][0];
            my $dy = $bodies->[$i][1] - $bodies->[$j][1];
            my $dz = $bodies->[$i][2] - $bodies->[$j][2];
            $e -= ($bodies->[$i][6] * $bodies->[$j][6]) / sqrt($dx*$dx + $dy*$dy + $dz*$dz);
        }
    }
    return $e;
}

my @bodies = (
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, $SOLAR_MASS],
    [4.84143144246472090, -1.16032004402742839, -0.103622044471123109,
     1.66007664274403694e-03 * $DAYS_PER_YEAR, 7.69901118419740425e-03 * $DAYS_PER_YEAR, -6.90460016972063023e-05 * $DAYS_PER_YEAR,
     9.54791938424326609e-04 * $SOLAR_MASS],
    [8.34336671824457987, 4.12479856412430479, -0.403523417114321381,
     -2.76742510726862411e-03 * $DAYS_PER_YEAR, 4.99852801234917238e-03 * $DAYS_PER_YEAR, 2.30417297573763929e-05 * $DAYS_PER_YEAR,
     2.85885980666130812e-04 * $SOLAR_MASS],
    [12.8943695621391310, -15.1111514016986312, -0.223307578892655734,
     2.96460137564761618e-03 * $DAYS_PER_YEAR, 2.37847173959480950e-03 * $DAYS_PER_YEAR, -2.96589568540237556e-05 * $DAYS_PER_YEAR,
     4.36624404335156298e-05 * $SOLAR_MASS],
    [15.3796971148509165, -25.9193146099879641, 0.179258772950371181,
     2.68067772490389322e-03 * $DAYS_PER_YEAR, 1.62824170038242295e-03 * $DAYS_PER_YEAR, -9.51592254519715870e-05 * $DAYS_PER_YEAR,
     5.15138902046611451e-05 * $SOLAR_MASS]
);

my $px = 0.0;
my $py = 0.0;
my $pz = 0.0;
for my $b (@bodies) {
    $px += $b->[3] * $b->[6];
    $py += $b->[4] * $b->[6];
    $pz += $b->[5] * $b->[6];
}
$bodies[0][3] = -$px / $SOLAR_MASS;
$bodies[0][4] = -$py / $SOLAR_MASS;
$bodies[0][5] = -$pz / $SOLAR_MASS;

my $start = time();
my $e1 = energy(\@bodies);
for my $i (1 .. 10000) {
    advance(\@bodies, 0.01);
}
my $e2 = energy(\@bodies);
my $end = time();

printf("Result: %.9f_%.9f\n", $e1, $e2);
printf("Time: %dms\n", ($end - $start) * 1000);
