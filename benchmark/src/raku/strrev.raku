my $n = 50000; my $s = "a" x $n; my $start = now * 1000;
my @buf; for $n - 1 ... 0 { @buf.push($s.substr($_, 1)) }; my $r = @buf.join;
my $end = now * 1000; say "Result: " ~ $r.substr(0, 1) ~ "/" ~ $r.chars; say "Time: " ~ ($end - $start).Int ~ "ms";
