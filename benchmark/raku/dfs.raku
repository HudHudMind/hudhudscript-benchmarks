my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my $n = 100; my @adj; for 0..$n-1 { my @row = 0 xx $n; @adj.push(@row); }; for 0..$n-1 -> $i { for 0..$n-1 -> $j { if ($i * 3 + $j * 7) % 11 == 0 && $i != $j { @adj[$i][$j] = 1; } } }; my $start = now * 1000; my @visited = False xx $n; my @stack = (0); my $count = 0;
while @stack.elems > 0 { my $node = @stack.pop();
    if !@visited[$node] { @visited[$node] = True; $count++;
        for (0..$n-1).reverse -> $neighbor { if @adj[$node][$neighbor] == 1 && !@visited[$neighbor] { @stack.push($neighbor); } } } }; my $end = now * 1000; say "Visited: " ~ $count; say "Time: " ~ ($end - $start).Int ~ "ms";