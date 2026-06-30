use strict;
use warnings;
use Time::HiRes qw(time);

sub mandelbrot {
    my $size = shift;
    my $sum_iters = 0;
    for (my $y = 0; $y < $size; $y++) {
        for (my $x = 0; $x < $size; $x++) {
            my $zr = 0.0; my $zi = 0.0;
            my $cr = (2.0 * $x / $size) - 1.5;
            my $ci = (2.0 * $y / $size) - 1.0;
            my $escape = 0;
            for (my $i = 0; $i < 50; $i++) {
                my $tr = $zr * $zr - $zi * $zi + $cr;
                my $ti = 2.0 * $zr * $zi + $ci;
                $zr = $tr;
                $zi = $ti;
                if ($zr * $zr + $zi * $zi > 4.0) {
                    $escape = 1;
                    last;
                }
            }
            $sum_iters += $escape;
        }
    }
    return $sum_iters;
}

my $start = time() * 1000;
my $res = mandelbrot(500);
my $end = time() * 1000;

print "Sum: $res\n";
printf "Time: %.0fms\n", ($end - $start);
