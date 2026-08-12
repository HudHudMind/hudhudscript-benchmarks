my $n = 300;
my @m;
for ^$n -> $i {
    my @r;
    for ^$n -> $j {
        @r.push($i + $j)
    }
    @m.push(@r)
}
# Separate output matrix t, full n*n assignments
my @t = [[0 xx $n] xx $n];
my $start = now * 1000;
for ^$n -> $i {
    for ^$n -> $j {
        @t[$j][$i] = @m[$i][$j]
    }
}
my $end = now * 1000;
say "Result: {@t[0][0]}/{@t[$n-1][$n-1]}";
say "Time: " ~ ($end - $start).Int ~ "ms";
