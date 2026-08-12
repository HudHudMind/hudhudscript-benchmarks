sub make_counter($start) {
    my $c = $start;
    return sub { $c = $c + 1; $c };
}

my $N = 150000;
my $acc = 0;
my $start = now * 1000;
for 0..$N-1 -> $i {
    my &ctr = make_counter($i % 1000);
    $acc = ($acc + ctr() + ctr() + ctr()) % 1000003;
}
my $end = now * 1000;
say "Result: " ~ $acc;
say "Time: " ~ ($end - $start).Int ~ "ms";
