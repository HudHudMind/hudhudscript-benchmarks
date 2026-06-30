my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
my $s = "a" x 50000;
my $start = now * 1000;
my $rev = "";
for (0..$s.chars - 1).reverse -> $j {
    $rev ~= $s.substr($j, 1);
}; my $end = now * 1000;
say "Len: " ~ $rev.chars;
say "Time: " ~ ($end - $start).Int ~ "ms";
