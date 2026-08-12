use strict;
use warnings;
use Time::HiRes qw(time);

sub bottom_up_tree {
    my $depth = shift;
    if ($depth > 0) {
        return [bottom_up_tree($depth - 1), bottom_up_tree($depth - 1)];
    } else {
        return [];
    }
}

sub item_check {
    my $tree = shift;
    if (@$tree) {
        return 1 + item_check($tree->[0]) + item_check($tree->[1]);
    } else {
        return 1;
    }
}

my $start = time() * 1000;
my $max_depth = 12;
my $min_depth = 4;
my $stretch_depth = $max_depth + 1;

my $stretch_tree = bottom_up_tree($stretch_depth);
my $check = item_check($stretch_tree);

my $long_lived_tree = bottom_up_tree($max_depth);

for (my $depth = $min_depth; $depth <= $max_depth; $depth += 2) {
    my $iterations = 1 << ($max_depth - $depth + $min_depth);
    my $check_sum = 0;
    for (my $i = 0; $i < $iterations; $i++) {
        $check_sum += item_check(bottom_up_tree($depth));
    }
}

my $long_lived_check = item_check($long_lived_tree);
my $end = time() * 1000;

print "Result: ${check}_${long_lived_check}\n";
printf "Time: %.0fms\n", ($end - $start);
