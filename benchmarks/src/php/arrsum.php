<?php
$arr = [];
for ($i = 0; $i < 10000; $i++) { $arr[] = $i; }
$start = hrtime(true);
$sum = 0;
for ($i = 0; $i < 10000; $i++) { $sum += $arr[$i]; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $sum . "
";
echo "Time: " . round($ms) . "ms
";
