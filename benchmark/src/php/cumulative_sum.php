<?php
$arr = [];
for ($i = 0; $i < 100000; $i++) { $arr[] = $i + 1; }
$start = hrtime(true);
$cum = []; $sum = 0;
for ($i = 0; $i < 100000; $i++) { $sum += $arr[$i]; $cum[] = $sum; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $cum[99999] . "\n";
echo "Time: " . round($ms) . "ms\n";
