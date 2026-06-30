<?php
$arr = [];
for ($i = 0; $i < 100000; $i++) { $arr[] = $i * 2; }
$start = hrtime(true);
$found = 0;
for ($j = 0; $j < 10000; $j++) {
    $target = $j * 20;
    if ($target >= 0 && $target < 200000 && $target % 2 == 0) { $found++; }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Found: " . $found . "
";
echo "Time: " . round($ms) . "ms
";
