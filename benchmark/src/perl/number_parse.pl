use Time::HiRes qw(time);
my $n = 200000; my $seed = 12345;
sub ri { my $m = shift; $seed = ($seed * 16807) % 2147483647; return $seed % $m; }
my @strings;
for (1..$n) {
    my $s = ""; $s = "-" if ri(2) == 0;
    my $nd = 1 + ri(9); $s .= (1 + ri(9));
    for (2..$nd) { $s .= ri(10); }
    push @strings, $s;
}
my $start = time(); my $total = 0; my $M = 1000003;
for my $s (@strings) {
    my $neg = 0; my $idx = 0;
    if (substr($s, 0, 1) eq '-') { $neg = 1; $idx = 1; }
    my $val = 0;
    while ($idx < length($s)) {
        my $c = substr($s, $idx, 1); my $d;
        if ($c eq '0') { $d = 0; } elsif ($c eq '1') { $d = 1; }
        elsif ($c eq '2') { $d = 2; } elsif ($c eq '3') { $d = 3; }
        elsif ($c eq '4') { $d = 4; } elsif ($c eq '5') { $d = 5; }
        elsif ($c eq '6') { $d = 6; } elsif ($c eq '7') { $d = 7; }
        elsif ($c eq '8') { $d = 8; } else { $d = 9; }
        $val = $val * 10 + $d; $idx++;
    }
    $val = -$val if $neg; $total += $val;
}
my $r = (($total % $M) + $M) % $M;
my $end = time(); my $ms = ($end - $start) * 1000;
print "Result: $r\n"; printf "Time: %.0fms\n", $ms;
