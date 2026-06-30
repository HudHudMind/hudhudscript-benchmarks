my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;
sub bottom-up-tree($depth) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    if $depth > 0 {
        return [bottom-up-tree($depth - 1), bottom-up-tree($depth - 1)];
    } else {
        return [];
    }
}

sub item-check($tree) {
    my int $i; my int $j; my int $k; my int $q; my int $idx; my int $m; my int $b;

    if $tree.elems > 0 {
        return 1 + item-check($tree[0]) + item-check($tree[1]);
    } else {
        return 1;
    }
}

my $start = now * 1000;
my $max-depth = 12;
my $min-depth = 4;
my $stretch-depth = $max-depth + 1;

my $stretch-tree = bottom-up-tree($stretch-depth);
my $check = item-check($stretch-tree);

my $long-lived-tree = bottom-up-tree($max-depth);

loop (my $depth = $min-depth; $depth <= $max-depth; $depth += 2) {
    my $iterations = 1 +< ($max-depth - $depth + $min-depth);
    my $check-sum = 0;
    loop (my $i = 0; $i < $iterations; $i++) {
        $check-sum += item-check(bottom-up-tree($depth));
    }
}

my $long-lived-check = item-check($long-lived-tree);
my $end = now * 1000;

put "Result: {$check}_$long-lived-check";
put "Time: ", ($end - $start).Int, "ms";
