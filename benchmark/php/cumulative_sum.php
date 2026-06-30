<?php
$arr = [];
for ($i = 0; $i < 100000; $i++) { $arr[] = $i + 1; }
$start = hrtime(true);
$sum = 0;
for ($i = 0; $i < 100000; $i++) { $sum += $arr[$i]; $arr[$i] = $sum; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Last: " . $arr[99999] . "
";
echo "Time: " . round($ms) . "ms
";
