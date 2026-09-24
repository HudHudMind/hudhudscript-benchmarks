use strict;
use warnings;
use Time::HiRes qw(time);

sub eval_A {
    my ($i, $j) = @_;
    return 1.0 / ((($i + $j) * ($i + $j + 1) / 2) + $i + 1);
}

sub eval_A_times_u {
    my ($u, $v, $n) = @_;
    for my $i (0 .. $n - 1) {
        $v->[$i] = 0.0;
        for my $j (0 .. $n - 1) {
            $v->[$i] += eval_A($i, $j) * $u->[$j];
        }
    }
}

sub eval_At_times_u {
    my ($u, $v, $n) = @_;
    for my $i (0 .. $n - 1) {
        $v->[$i] = 0.0;
        for my $j (0 .. $n - 1) {
            $v->[$i] += eval_A($j, $i) * $u->[$j];
        }
    }
}

sub eval_AtA_times_u {
    my ($u, $v, $w, $n) = @_;
    eval_A_times_u($u, $w, $n);
    eval_At_times_u($w, $v, $n);
}

my $start = time();
my $n = 150;
my @u = (1.0) x $n;
my @v = (0.0) x $n;
my @w = (0.0) x $n;

for my $i (1 .. 10) {
    eval_AtA_times_u(\@u, \@v, \@w, $n);
    eval_AtA_times_u(\@v, \@u, \@w, $n);
}

my $vBv = 0.0;
my $vv = 0.0;
for my $i (0 .. $n - 1) {
    $vBv += $u[$i] * $v[$i];
    $vv += $v[$i] * $v[$i];
}

my $res = sqrt($vBv / $vv);
my $end = time();

printf("Result: %.9f\n", $res);
printf("Time: %dms\n", ($end - $start) * 1000);
