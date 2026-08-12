sub f3($i) { die "boom" if $i % 7 == 0; $i * 2 }
sub f2($i) { f3($i) }
sub f1($i) { f2($i) }
my $N = 200000; my ($acc, $caught) = (0, 0); my $start = now * 1000;
for 1..$N -> $i {
    try { $acc = ($acc + f1($i)) % 1000003 };
    $caught++ if $!;
}
my $end = now * 1000;
say "Result: {$acc}_{$caught}"; say "Time: " ~ ($end - $start).Int ~ "ms";
