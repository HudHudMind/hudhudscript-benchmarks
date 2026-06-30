<?php
$n = 500;
$arr = [];
for ($i = $n; $i > 0; $i--) { $arr[] = $i; }
$start = hrtime(true);
for ($k = 0; $k < $n; $k++) {
    for ($j = 0; $j < $n - 1; $j++) {
        if ($arr[$j] > $arr[$j + 1]) {
            $t = $arr[$j]; $arr[$j] = $arr[$j + 1]; $arr[$j + 1] = $t;
        }
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
