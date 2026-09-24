<?php
function bottom_up_tree($depth) {
    if ($depth > 0) {
        return [bottom_up_tree($depth - 1), bottom_up_tree($depth - 1)];
    } else {
        return [];
    }
}

function item_check($tree) {
    if (count($tree) > 0) {
        return 1 + item_check($tree[0]) + item_check($tree[1]);
    } else {
        return 1;
    }
}

$start = microtime(true) * 1000;
$max_depth = 12;
$min_depth = 4;
$stretch_depth = $max_depth + 1;

$stretch_tree = bottom_up_tree($stretch_depth);
$check = item_check($stretch_tree);

$long_lived_tree = bottom_up_tree($max_depth);

for ($depth = $min_depth; $depth <= $max_depth; $depth += 2) {
    $iterations = 1 << ($max_depth - $depth + $min_depth);
    $check_sum = 0;
    for ($i = 0; $i < $iterations; $i++) {
        $check_sum += item_check(bottom_up_tree($depth));
    }
}

$long_lived_check = item_check($long_lived_tree);
$end = microtime(true) * 1000;

echo "Result: " . $check . "_" . $long_lived_check . "\n";
echo "Time: " . round($end - $start) . "ms\n";
?>
