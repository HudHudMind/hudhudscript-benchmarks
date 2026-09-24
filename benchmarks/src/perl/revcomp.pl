use strict;
use warnings;
use Time::HiRes qw(time);

my %comp = (
    'A' => 'T', 'C' => 'G', 'G' => 'C', 'T' => 'A',
    'U' => 'A', 'M' => 'K', 'R' => 'Y', 'W' => 'W',
    'S' => 'S', 'Y' => 'R', 'K' => 'M', 'V' => 'B',
    'H' => 'D', 'D' => 'H', 'B' => 'V', 'N' => 'N',
    'a' => 'T', 'c' => 'G', 'g' => 'C', 't' => 'A',
    'u' => 'A', 'm' => 'K', 'r' => 'Y', 'w' => 'W',
    's' => 'S', 'y' => 'R', 'k' => 'M', 'v' => 'B',
    'h' => 'D', 'd' => 'H', 'b' => 'V', 'n' => 'N'
);

sub reverse_complement {
    my ($seq) = @_;
    my $count_A = 0;
    for (my $i = length($seq) - 1; $i >= 0; $i--) {
        my $c = substr($seq, $i, 1);
        my $rep = exists $comp{$c} ? $comp{$c} : $c;
        if ($rep eq 'A') {
            $count_A++;
        }
    }
    return $count_A;
}

my $start = time();

my @seq = ();
my $seed = 42;
my @chars = ('A', 'C', 'G', 'T');
for my $i (1 .. 500000) {
    $seed = ($seed * 1103515245 + 12345) & 0x7fffffff;
    my $idx = ($seed >> 16) % 4;
    push @seq, $chars[$idx];
}
my $seq_str = join("", @seq);

my $res = 0;
for my $i (1 .. 10) {
    $res = reverse_complement($seq_str);
}

my $end = time();
print "Result: $res\n";
printf("Time: %dms\n", ($end - $start) * 1000);
