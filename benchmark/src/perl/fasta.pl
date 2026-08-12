use strict;
use warnings;
use Time::HiRes qw(time);

my $start = time();

my $seed = 42;
sub rand_val {
    my ($max_val) = @_;
    $seed = ($seed * 3877 + 29573) % 139968;
    return $max_val * $seed / 139968.0;
}

my $alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

my @iub = (
    ['a', 0.27], ['c', 0.12], ['g', 0.12], ['t', 0.27],
    ['B', 0.02], ['D', 0.02], ['H', 0.02], ['K', 0.02],
    ['M', 0.02], ['N', 0.02], ['R', 0.02], ['S', 0.02],
    ['V', 0.02], ['W', 0.02], ['Y', 0.02]
);

my $cp = 0.0;
for my $x (@iub) {
    $cp += $x->[1];
    $x->[1] = $cp;
}

my $res = 0;
my $n = 50000;

my $total = $n * 2;
while ($total > 0) {
    my $chunk = $total < 60 ? $total : 60;
    $res += $chunk;
    $total -= $chunk;
}

$total = $n * 3;
while ($total > 0) {
    my $chunk = $total < 60 ? $total : 60;
    for my $c (1 .. $chunk) {
        my $r = rand_val(1.0);
        for my $j (0 .. scalar(@iub) - 1) {
            if ($r < $iub[$j][1]) {
                $res++;
                last;
            }
        }
    }
    $total -= $chunk;
}

my $end = time();
print "Result: $res\n";
printf("Time: %dms\n", ($end - $start) * 1000);
