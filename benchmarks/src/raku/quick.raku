my $n = 1000; my @a = (1..$n).reverse; my $start = now * 1000;
my @stack; @stack.push(0); @stack.push($n - 1);
while @stack {
    my $high = @stack.pop; my $low = @stack.pop;
    if $low < $high {
        my $pivot = @a[$high]; my $i = $low - 1;
        for $low..^$high {
            if @a[$_] <= $pivot { $i++; (@a[$i], @a[$_]) = (@a[$_], @a[$i]) }
        }
        $i++; (@a[$i], @a[$high]) = (@a[$high], @a[$i]);
        if $i - 1 > $low { @stack.push($low); @stack.push($i - 1) }
        if $i + 1 < $high { @stack.push($i + 1); @stack.push($high) }
    }
}
my $end = now * 1000;
say "Result: {@a[0]}/{@a[$n-1]}";
say "Time: " ~ ($end - $start).Int ~ "ms";
