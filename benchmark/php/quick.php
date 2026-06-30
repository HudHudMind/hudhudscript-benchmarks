<?php
$n = 1000;
$arr = [];
for ($i = $n; $i > 0; $i--) { $arr[] = $i; }
$start = hrtime(true);
$stack = [0, $n - 1];
while (count($stack) > 0) {
    $high = array_pop($stack);
    $low = array_pop($stack);
    if ($low < $high) {
        $pivot = $arr[$high];
        $pi = $low - 1;
        for ($j = $low; $j < $high; $j++) {
            if ($arr[$j] <= $pivot) { $pi++; $t = $arr[$pi]; $arr[$pi] = $arr[$j]; $arr[$j] = $t; }
        }
        $pi++; $t = $arr[$pi]; $arr[$pi] = $arr[$high]; $arr[$high] = $t;
        if ($pi - 1 > $low) { $stack[] = $low; $stack[] = $pi - 1; }
        if ($pi + 1 < $high) { $stack[] = $pi + 1; $stack[] = $high; }
    }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "First: " . $arr[0] . "
";
echo "Last: " . $arr[$n - 1] . "
";
echo "Time: " . round($ms) . "ms
";
