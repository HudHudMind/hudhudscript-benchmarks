my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub isPal($s) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $l = 0; my $r = $s.chars - 1; while $l < $r { return 0 if $s.substr($l, 1) ne $s.substr($r, 1); $l++; $r--; }; return 1; }; my $start = now * 1000; my $res = 0; my $s = "a" x 5000 ~ "b" ~ "a" x 5000; for 1..10000 { $res = isPal($s); }; my $end = now * 1000; say "IsPal: " ~ $res; say "Time: " ~ ($end - $start).Int ~ "ms";