use strict;
use warnings;
use Time::HiRes qw(time);

sub generate_dna {
    my $length = shift;
    my @chars = ('A', 'C', 'G', 'T');
    my $seq = "";
    my $seed = 42;
    for (my $i = 0; $i < $length; $i++) {
        $seed = ($seed * 1103515245 + 12345) & 0x7fffffff;
        my $idx = ($seed >> 16) % 4;
        $seq .= $chars[$idx];
    }
    return $seq;
}

sub count_frequencies {
    my ($dna, $k) = @_;
    my %freqs;
    my $n = length($dna) - $k + 1;
    for (my $i = 0; $i < $n; $i++) {
        my $sub = substr($dna, $i, $k);
        $freqs{$sub}++;
    }
    return scalar keys %freqs;
}

my $start = time() * 1000;
my $dna = generate_dna(100000);
my $c1 = count_frequencies($dna, 1);
my $c2 = count_frequencies($dna, 2);
my $c3 = count_frequencies($dna, 3);
my $res = $c1 + $c2 + $c3;
my $end = time() * 1000;

print "Count: $res\n";
printf "Time: %.0fms\n", ($end - $start);
