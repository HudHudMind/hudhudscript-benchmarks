my $N = 20000;
my @arr;
my $seed = 12345;
for ^$N {
    $seed = ($seed * 16807) % 2147483647;
    @arr.push($seed % 1000000);
}

sub quicksort(@a, $l, $h, &cmp) {
    return if $l >= $h;
    my @s = ($l, $h);
    while @s {
        my $h2 = @s.pop;
        my $l2 = @s.pop;
        next if $l2 >= $h2;
        my $p = @a[($l2 + $h2) div 2];
        my ($i2, $j2) = ($l2, $h2);
        while $i2 <= $j2 {
            $i2++ while &cmp(@a[$i2], $p) < 0;
            $j2-- while &cmp(@a[$j2], $p) > 0;
            if $i2 <= $j2 {
                (@a[$i2], @a[$j2]) = (@a[$j2], @a[$i2]);
                $i2++;
                $j2--;
            }
        }
        @s.push($l2, $j2) if $l2 < $j2;
        @s.push($i2, $h2) if $i2 < $h2;
    }
}

my &asc = -> $a, $b { $a - $b };
my &desc = -> $a, $b { $b - $a };

my $start = now * 1000;
my @c1 = @arr;
quicksort(@c1, 0, $N - 1, &asc);
my @c2 = @arr;
quicksort(@c2, 0, $N - 1, &desc);

my ($r1, $r2) = (0, 0);
for ^$N {
    $r1 = ($r1 + @c1[$_] * ($_ % 7)) % 1000003;
    $r2 = ($r2 + @c2[$_] * ($_ % 7)) % 1000003;
}
my $end = now * 1000;
say "Result: {$r1}_{$r2}";
say "Time: " ~ ($end - $start).Int ~ "ms";
