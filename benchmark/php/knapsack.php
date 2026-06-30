<?php
$weights = [];
$values = [];
for ($i = 0; $i < 50; $i++) {
    $weights[] = ($i * 7 + 3) % 20 + 1;
    $values[] = ($i * 13 + 5) % 50 + 10;
}
$capacity = 100;
$n = count($weights);
$start = hrtime(true);
$dp = [];
for ($i = 0; $i <= $n; $i++) {
    $dp[$i] = array_fill(0, $capacity + 1, 0);
}
for ($i = 1; $i <= $n; $i++) {
    for ($w = 0; $w <= $capacity; $w++) {
        if ($weights[$i - 1] <= $w) {
            $incl = $values[$i - 1] + $dp[$i - 1][$w - $weights[$i - 1]];
            $dp[$i][$w] = $incl > $dp[$i - 1][$w] ? $incl : $dp[$i - 1][$w];
        } else {
            $dp[$i][$w] = $dp[$i - 1][$w];
        }
    }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Max: " . $dp[$n][$capacity] . "
";
echo "Time: " . round($ms) . "ms
";
