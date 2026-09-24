sub duffs-device(@a, @b, Int $count) {
    my int $n = $count div 8;
    my int $rem = $count % 8;
    my int $i = 0;
    
    while $rem > 0 {
        @a[$i] = @b[$i];
        $i++;
        $rem--;
    }
    
    while $n > 0 {
        @a[$i] = @b[$i]; $i++;
        @a[$i] = @b[$i]; $i++;
        @a[$i] = @b[$i]; $i++;
        @a[$i] = @b[$i]; $i++;
        @a[$i] = @b[$i]; $i++;
        @a[$i] = @b[$i]; $i++;
        @a[$i] = @b[$i]; $i++;
        @a[$i] = @b[$i]; $i++;
        $n--;
    }
    return @a[$count - 1];
}

my @a = 0 xx 100000;
my @b = 1 xx 100000;
my $start = now * 1000;
my $res = 0;
loop (my $k = 0; $k < 100; $k++) {
    $res = duffs-device(@a, @b, 100000);
}
my $end = now * 1000;

put "Result: $res";
put "Time: ", ($end - $start).Int, "ms";
