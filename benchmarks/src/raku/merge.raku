my $n = 1000; my @a = (1..$n).reverse; my $start = now * 1000;
my $width = 1;
while $width < $n {
    my $i = 0;
    while $i < $n {
        my $mid = $i + $width;
        if $mid >= $n { $i += 2 * $width; next }
        my $end = ($i + 2 * $width < $n) ?? $i + 2 * $width !! $n;
        my @L = @a[$i .. $mid - 1];
        my @R = @a[$mid .. $end - 1];
        my ($li, $ri, $ai) = (0, 0, $i);
        while $li < @L && $ri < @R {
            @a[$ai++] = @L[$li] <= @R[$ri] ?? @L[$li++] !! @R[$ri++];
        }
        @a[$ai++] = @L[$li++] while $li < @L;
        @a[$ai++] = @R[$ri++] while $ri < @R;
        $i += 2 * $width;
    }
    $width *= 2;
}
my $end = now * 1000;
say "Result: {@a[0]}/$n";
say "Time: " ~ ($end - $start).Int ~ "ms";
