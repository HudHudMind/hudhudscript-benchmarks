my $seed = 42;
sub rng() {
    $seed = ($seed * 1103515245 + 12345) % 2147483648;
    return (($seed - ($seed % 65536)) div 65536) % 4;
}
my $chars = "ACGT";
my @ta;
for ^500000 { @ta.push($chars.substr(rng(), 1)); }
my $text = @ta.join("");

my @patterns;
for ^15 {
    my $sp = ($seed * 16807) % 499000;
    $seed = ($seed * 16807) % 2147483647;
    my $pl = 5 + ($seed % 11);
    @patterns.push($text.substr($sp, $pl));
}
for ^5 {
    @patterns.push("QQQQQ" ~ (($seed * 16807) % 10).Str);
    $seed = ($seed * 16807) % 2147483647;
}

my $start = now * 1000;
my $total = 0;
for @patterns -> $pat {
    my $m = $pat.chars;
    my @fail = 0 xx $m;
    my $j = 0;
    for 1..^$m -> $i {
        while $j > 0 && $pat.substr($i, 1) ne $pat.substr($j, 1) { $j = @fail[$j - 1]; }
        if $pat.substr($i, 1) eq $pat.substr($j, 1) { $j++; }
        @fail[$i] = $j;
    }
    $j = 0;
    for ^$text.chars -> $i {
        my $c = $text.substr($i, 1);
        while $j > 0 && $c ne $pat.substr($j, 1) { $j = @fail[$j - 1]; }
        if $c eq $pat.substr($j, 1) { $j++; }
        if $j == $m { $total++; $j = @fail[$j - 1]; }
    }
}
my $end = now * 1000;
say "Result: $total";
say "Time: " ~ ($end - $start).Int ~ "ms";
