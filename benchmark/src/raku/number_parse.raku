my $n = 200000; my $seed = 12345;
sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m; }
my @strings;
for ^$n {
    my $s = ""; $s = "-" if ri(2) == 0;
    my $nd = 1 + ri(9); $s ~= (1 + ri(9)).Str;
    for 2..$nd { $s ~= ri(10).Str; }
    @strings.push($s);
}
my $start = now * 1000; my $total = 0; my $M = 1000003;
for @strings -> $s {
    my $neg = False; my $idx = 0;
    if $s.substr(0, 1) eq '-' { $neg = True; $idx = 1; }
    my $val = 0;
    while $idx < $s.chars {
        my $c = $s.substr($idx, 1); my $d;
        if $c eq '0' { $d = 0; } elsif $c eq '1' { $d = 1; }
        elsif $c eq '2' { $d = 2; } elsif $c eq '3' { $d = 3; }
        elsif $c eq '4' { $d = 4; } elsif $c eq '5' { $d = 5; }
        elsif $c eq '6' { $d = 6; } elsif $c eq '7' { $d = 7; }
        elsif $c eq '8' { $d = 8; } else { $d = 9; }
        $val = $val * 10 + $d; $idx++;
    }
    $val = -$val if $neg; $total += $val;
}
my $r = (($total % $M) + $M) % $M;
my $end = now * 1000;
say "Result: $r"; say "Time: " ~ ($end - $start).Int ~ "ms";
