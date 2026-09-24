my $n = 1000; my @a = (1..$n).reverse; my $start = now * 1000;
for 1..^$n -> $i {
    my $key = @a[$i]; my $j = $i - 1;
    while $j >= 0 && @a[$j] > $key { @a[$j + 1] = @a[$j]; $j-- }
    @a[$j + 1] = $key;
}
my $end = now * 1000;
say "Result: {@a[0]}/{@a[$n-1]}";
say "Time: " ~ ($end - $start).Int ~ "ms";
