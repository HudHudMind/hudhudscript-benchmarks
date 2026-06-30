my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my %comp =
    'A' => 'T', 'C' => 'G', 'G' => 'C', 'T' => 'A',
    'U' => 'A', 'M' => 'K', 'R' => 'Y', 'W' => 'W',
    'S' => 'S', 'Y' => 'R', 'K' => 'M', 'V' => 'B',
    'H' => 'D', 'D' => 'H', 'B' => 'V', 'N' => 'N',
    'a' => 'T', 'c' => 'G', 'g' => 'C', 't' => 'A',
    'u' => 'A', 'm' => 'K', 'r' => 'Y', 'w' => 'W',
    's' => 'S', 'y' => 'R', 'k' => 'M', 'v' => 'B',
    'h' => 'D', 'd' => 'H', 'b' => 'V', 'n' => 'N';

sub reverse_complement($seq) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    my int $count_A = 0;
    loop ($i = $seq.chars - 1; $i >= 0; $i = $i - 1) {
        my str $c = substr($seq, $i, 1);
        my str $rep = %comp{$c} // $c;
        if $rep eq 'A' {
            $count_A = $count_A + 1;
        }
    }
    return $count_A;
}

my $start_time = now;

my @seq;
my int $seed = 42;
my @chars = 'A', 'C', 'G', 'T';
loop ($i = 0; $i < 500000; $i = $i + 1) {
    $seed = ($seed * 1103515245 + 12345) +& 0x7fffffff;
    my int $idx = ($seed +> 16) % 4;
    @seq.push(@chars[$idx]);
}
my $seq_str = @seq.join("");

my int $res = 0;
loop ($i = 0; $i < 10; $i = $i + 1) {
    $res = reverse_complement($seq_str);
}

my $end_time = now;
say "Result: $res";
printf("Time: %dms\n", (($end_time - $start_time) * 1000).Int);
