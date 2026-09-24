my $n = 200000; my $U = 400000; my @parent; @parent.append(^$n); my @size = 1 xx $n;
sub find($x is copy) { while @parent[$x] != $x { $x = @parent[$x] }; $x }
sub union($a, $b) { my $ra = find($a); my $rb = find($b); return if $ra == $rb;
    if @size[$ra] < @size[$rb] { @parent[$ra] = $rb; @size[$rb] += @size[$ra] }
    else { @parent[$rb] = $ra; @size[$ra] += @size[$rb] } }
my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my $start = now * 1000;
for ^$U { union(ri($n), ri($n)) }
my $roots = 0; for ^$n { $roots++ if @parent[$_] == $_ }
my $end = now * 1000;
say "Result: $roots"; say "Time: " ~ ($end - $start).Int ~ "ms";
