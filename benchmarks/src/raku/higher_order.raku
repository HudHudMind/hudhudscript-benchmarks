my @base = 0..999;
my $R = 2000;
my $acc = 0;
my $start = now * 1000;
for ^$R {
    my @d = @base.map({ $_ * 2 + 1 });
    my @f = @d.grep({ $_ % 3 != 0 });
    my $s = reduce { $^a + $^b }, 0, |@f;
    $acc = ($acc + $s + @f.elems) % 1000003;
}
my $end = now * 1000;
say "Result: " ~ $acc;
say "Time: " ~ ($end - $start).Int ~ "ms";
