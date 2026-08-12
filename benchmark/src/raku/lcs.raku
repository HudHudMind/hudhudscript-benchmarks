my $a = "abcdefghij" x 10; my $b = "acegikmoqs" x 10;
my $m = $a.chars; my $n = $b.chars; my $start = now * 1000;
my @dp = [[0 xx ($n+1)] xx ($m+1)];
for ^$m -> $i { for ^$n -> $j {
    if $a.substr($i,1) eq $b.substr($j,1) { @dp[$i+1][$j+1] = @dp[$i][$j] + 1 }
    else { @dp[$i+1][$j+1] = max(@dp[$i][$j+1], @dp[$i+1][$j]) }
}}
my $end = now * 1000;
say "Result: {@dp[$m][$n]}";
say "Time: " ~ ($end - $start).Int ~ "ms";
