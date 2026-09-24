use strict;
use warnings;
use Time::HiRes qw(time);

sub fannkuch {
    my ($n) = @_;
    my @p = (0 .. $n - 1);
    my @q = (0 .. $n - 1);
    my @s = (0 .. $n - 1);
    my $sign = 1;
    my $maxflips = 0;
    my $sumflips = 0;

    while (1) {
        my $q1 = $p[0];
        if ($q1 != 0) {
            for my $i (1 .. $n - 1) { $q[$i] = $p[$i]; }
            my $flips = 1;
            while (1) {
                my $qq = $q[$q1];
                last if $qq == 0;
                $q[$q1] = $q1;
                if ($q1 >= 3) {
                    my $i = 1;
                    my $j = $q1 - 1;
                    while ($i < $j) {
                        my $t = $q[$i];
                        $q[$i] = $q[$j];
                        $q[$j] = $t;
                        $i++;
                        $j--;
                    }
                }
                $q1 = $qq;
                $flips++;
            }
            $maxflips = $flips if $flips > $maxflips;
            $sumflips += $sign * $flips;
        }

        if ($sign == 1) {
            my $t = $p[1];
            $p[1] = $p[0];
            $p[0] = $t;
            $sign = -1;
        } else {
            my $t = $p[1];
            $p[1] = $p[2];
            $p[2] = $t;
            $sign = 1;
            my $k = 2;
            while ($k < $n) {
                $s[$k]--;
                last if $s[$k] != 0;
                $s[$k] = $k;
                my $t0 = $p[0];
                for my $m (0 .. $k) {
                    $p[$m] = $m < $k ? $p[$m + 1] : $t0;
                }
                $k++;
            }
            last if $k == $n;
        }
    }
    return "${sumflips}_${maxflips}";
}

my $start = time();
my $res = fannkuch(9);
my $end = time();

print "Result: $res\n";
printf("Time: %dms\n", ($end - $start) * 1000);
