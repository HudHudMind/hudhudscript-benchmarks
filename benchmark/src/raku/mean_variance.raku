my $n = 1000000; my @a; for 1..$n { @a.push($_) }
my $start = now * 1000;
my $m = 0e0; $m += $_ for @a; $m /= $n;
my $v = 0e0; $v += ($_ - $m) * ($_ - $m) for @a; $v /= $n;
my $end = now * 1000;
say "Result: " ~ $m.round(0.1) ~ "/" ~ $v.round(0.1);
say "Time: " ~ ($end - $start).Int ~ "ms";
