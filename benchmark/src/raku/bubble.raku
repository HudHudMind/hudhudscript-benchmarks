my $n = 500; my @a = (1..$n).reverse; my $start = now * 1000;
for ^$n { for ^($n - 1) -> $j { if @a[$j] > @a[$j + 1] { (@a[$j], @a[$j + 1]) = (@a[$j + 1], @a[$j]) } } }
my $end = now * 1000;
say "Result: {@a[0]}/{@a[$n-1]}";
say "Time: " ~ ($end - $start).Int ~ "ms";
