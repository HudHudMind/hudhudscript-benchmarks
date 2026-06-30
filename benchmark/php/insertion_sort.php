<?php
$n = 1000;
$arr = [];
for ($i = $n; $i > 0; $i--) { $arr[] = $i; }
$start = hrtime(true);
for ($j = 1; $j < $n; $j++) {
    $key = $arr[$j]; $k = $j - 1;
    while ($k >= 0 && $arr[$k] > $key) { $arr[$k + 1] = $arr[$k]; $k--; }
    $arr[$k + 1] = $key;
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "First: " . $arr[0] . "
";
echo "Last: " . $arr[$n - 1] . "
";
echo "Time: " . round($ms) . "ms
";
