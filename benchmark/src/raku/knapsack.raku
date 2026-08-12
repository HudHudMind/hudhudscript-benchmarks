my $n = 50; my $W = 100;
my @w; my @v;
for ^$n { @w.push(($_ * 7 + 3) % 20 + 1); @v.push(($_ * 13 + 5) % 50 + 10) }
my $start = now * 1000;
my @dp = [[0 xx ($W+1)] xx ($n+1)];
for ^$n -> $i { for 0..$W -> $j {
    if @w[$i] <= $j { @dp[$i+1][$j] = max(@dp[$i][$j], @dp[$i][$j - @w[$i]] + @v[$i]) }
    else { @dp[$i+1][$j] = @dp[$i][$j] }
}}
my $end = now * 1000;
say "Result: {@dp[$n][$W]}";
say "Time: " ~ ($end - $start).Int ~ "ms";
