my $seed = 12345;
sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m; }

sub gen($depth) {
    return ri(100000) if $depth == 7;
    my %node;
    %node<a> = ri(4) == 0 ?? ri(100000) !! gen($depth + 1);
    %node<b> = ri(4) == 0 ?? ri(100000) !! gen($depth + 1);
    %node<c> = ri(4) == 0 ?? ri(100000) !! gen($depth + 1);
    %node<s> = "x" ~ ri(1000).Str;
    return %node;
}

sub count-nodes($node) {
    return 0 if $node ~~ Int || $node ~~ Str;
    return 1 + count-nodes($node<a>) + count-nodes($node<b>) + count-nodes($node<c>);
}

sub serialize($node) {
    return $node.Str if $node ~~ Int;
    my @parts = ();
    @parts.push('{"a":');
    @parts.push(serialize($node<a>));
    @parts.push(',"b":');
    @parts.push(serialize($node<b>));
    @parts.push(',"c":');
    @parts.push(serialize($node<c>));
    @parts.push(',"s":"');
    @parts.push($node<s>);
    @parts.push('"}');
    return @parts.join("");
}

my $tree = gen(0);
my $nc = count-nodes($tree);
my $start = now * 1000;
my $total = 0;
for ^50 { $total += serialize($tree).chars; }
my $end = now * 1000;
say "Result: " ~ ($total % 1000003) ~ "_" ~ $nc;
say "Time: " ~ ($end - $start).Int ~ "ms";
