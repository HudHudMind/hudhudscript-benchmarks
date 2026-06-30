sub generate-dna($length) {
    my @chars = <A C G T>;
    my $seq = "";
    my int $seed = 42;
    loop (my $i = 0; $i < $length; $i++) {
        $seed = ($seed * 1103515245 + 12345) +& 0x7fffffff;
        my $idx = ($seed +> 16) % 4;
        $seq ~= @chars[$idx];
    }
    return $seq;
}

sub count-frequencies($dna, $k) {
    my %freqs;
    my $n = $dna.chars - $k + 1;
    loop (my $i = 0; $i < $n; $i++) {
        my $sub = $dna.substr($i, $k);
        %freqs{$sub}++;
    }
    return %freqs.elems;
}

my $start = now * 1000;
my $dna = generate-dna(100000);
my $c1 = count-frequencies($dna, 1);
my $c2 = count-frequencies($dna, 2);
my $c3 = count-frequencies($dna, 3);
my $res = $c1 + $c2 + $c3;
my $end = now * 1000;

put "Count: $res";
put "Time: ", ($end - $start).Int, "ms";
