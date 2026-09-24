my $seed = 12345;
my $line = '';
for ^40 {
    $seed = ($seed * 16807) % 2147483647;
    my $fn = ($seed % 1000) + 100;
    $line ~= "f$fn";
    $line ~= ',' if $_ < 39;
}

my $R = 10000;
my ($sp, $si, $ss) = (0, 0, 0);
my $start = now * 1000;
for ^$R {
    my @parts = $line.split(',');
    for @parts {
        $sp += @parts.elems;
        $si += $_.index('f') // 0;
        $ss += $_.substr(1, 2).chars if $_.chars >= 4;
    }
}
my $acc = (($sp % 1000003) + ($si % 1000003) + ($ss % 1000003)) % 1000003;
my $end = now * 1000;
say "Result: $acc";
say "Time: " ~ ($end - $start).Int ~ "ms";
