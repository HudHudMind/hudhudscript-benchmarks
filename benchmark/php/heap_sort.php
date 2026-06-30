<?php
$n = 1000;
$arr = [];
for ($i = $n; $i > 0; $i--) { $arr[] = $i; }
$start = hrtime(true);
for ($i = intdiv($n, 2) - 1; $i >= 0; $i--) {
    $idx = $i;
    while (true) {
        $largest = $idx; $left = 2 * $idx + 1; $right = 2 * $idx + 2;
        if ($left < $n && $arr[$left] > $arr[$largest]) $largest = $left;
        if ($right < $n && $arr[$right] > $arr[$largest]) $largest = $right;
        if ($largest == $idx) break;
        $t = $arr[$idx]; $arr[$idx] = $arr[$largest]; $arr[$largest] = $t;
        $idx = $largest;
    }
}
for ($i = $n - 1; $i > 0; $i--) {
    $t = $arr[0]; $arr[0] = $arr[$i]; $arr[$i] = $t;
    $idx = 0; $size = $i;
    while (true) {
        $largest = $idx; $left = 2 * $idx + 1; $right = 2 * $idx + 2;
        if ($left < $size && $arr[$left] > $arr[$largest]) $largest = $left;
        if ($right < $size && $arr[$right] > $arr[$largest]) $largest = $right;
        if ($largest == $idx) break;
        $t = $arr[$idx]; $arr[$idx] = $arr[$largest]; $arr[$largest] = $t;
        $idx = $largest;
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
