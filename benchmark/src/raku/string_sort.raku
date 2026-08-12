my $N = 20000; my $seed = 12345; sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my @arr; for ^$N { @arr.push('w' ~ ri(100000)) }
sub ms(@a) { return @a if @a.elems <= 1; my $m = @a.elems div 2;
    my @L = ms(@a[0 .. $m - 1]); my @R = ms(@a[$m .. *]);
    my @res; my ($pi, $qi) = (0, 0);
    while $pi < @L.elems { last if $qi >= @R.elems;
        if @L[$pi] le @R[$qi] { @res.push(@L[$pi]); $pi++ } else { @res.push(@R[$qi]); $qi++ } }
    @res.append(@L[$pi..*]) if $pi < @L.elems; @res.append(@R[$qi..*]) if $qi < @R.elems; @res }
my $start = now * 1000; my @s = ms(@arr);
my $acc = 0; for ^$N { $acc = ($acc + @s[$_].chars * ($_ % 13)) % 1000003 }
my $end = now * 1000; say "Result: $acc"; say "Time: " ~ ($end - $start).Int ~ "ms";
