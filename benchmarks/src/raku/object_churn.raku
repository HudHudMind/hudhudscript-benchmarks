my $N = 500000;
my $acc = 0;
my $start = now * 1000;
for 0..$N-1 -> $i {
    my %p = (x => $i, y => $i * 2, z => 0);
    %p<z> = %p<x> + %p<y>;
    $acc = ($acc + %p<z>) % 1000003;
}
my $end = now * 1000;
say "Result: " ~ $acc;
say "Time: " ~ ($end - $start).Int ~ "ms";
