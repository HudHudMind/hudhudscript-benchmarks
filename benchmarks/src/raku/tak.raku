sub tak($x, $y, $z) {
    if $y < $x {
        return tak(
            tak($x - 1, $y, $z),
            tak($y - 1, $z, $x),
            tak($z - 1, $x, $y)
        );
    }
    return $z;
}

my $start = now * 1000;
my $res = 0;
loop (my $i = 0; $i < 10; $i++) {
    $res = tak(18, 12, 6);
}
my $end = now * 1000;

put "Result: $res";
put "Time: ", ($end - $start).Int, "ms";
