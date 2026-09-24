my $hay = "abcdefghij" x 1000; my $needle = "defg";
my $found = 0; my $start = now * 1000;
for ^($hay.chars - $needle.chars + 1) -> $i {
    my $match = True;
    for ^$needle.chars -> $j {
        if $hay.substr($i + $j, 1) ne $needle.substr($j, 1) { $match = False; last }
    }
    if $match { $found++ }
}
my $end = now * 1000;
say "Result: $found";
say "Time: " ~ ($end - $start).Int ~ "ms";
