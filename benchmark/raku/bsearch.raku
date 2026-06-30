my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub bsearch(@arr, $x) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $l = 0; my $r = @arr.elems - 1;
    while $l <= $r { my $m = $l + ($r - $l) div 2; if @arr[$m] == $x { return $m; } elsif @arr[$m] < $x { $l = $m + 1; } else { $r = $m - 1; } }; return -1; }; my @arr = 1..100000; my $start = now * 1000; my $found = 0;
for 1..10000 -> $i { if bsearch(@arr, $i * 5) != -1 { $found++; } }; my $end = now * 1000; say "Found: " ~ $found; say "Time: " ~ ($end - $start).Int ~ "ms";