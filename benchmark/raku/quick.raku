my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub partition(@arr, $l, $h) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 my $p = @arr[$h]; my $i = $l - 1; for $l..$h-1 -> $j {
        if @arr[$j] <= $p { $i++; my $t = @arr[$i]; @arr[$i] = @arr[$j]; @arr[$j] = $t; } }; my $t = @arr[$i+1]; @arr[$i+1] = @arr[$h]; @arr[$h] = $t; return $i + 1; }
sub quick(@arr, $l, $h) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
 if $l < $h { my $pi = partition(@arr, $l, $h); quick(@arr, $l, $pi - 1); quick(@arr, $pi + 1, $h); } }; my $start = now * 1000; my $first = 0; for 1..100 { my @arr = (1..1000).reverse; quick(@arr, 0, 999); $first = @arr[0]; }; my $end = now * 1000; say "First: " ~ $first; say "Time: " ~ ($end - $start).Int ~ "ms";