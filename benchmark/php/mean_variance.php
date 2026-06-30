<?php
$arr = [];
for ($i = 0; $i < 1000000; $i++) { $arr[] = $i + 1; }
$n = 1000000;
$start = hrtime(true);
$sum = 0;
for ($i = 0; $i < $n; $i++) { $sum += $arr[$i]; }
$mean = $sum / $n;
$sq = 0;
for ($i = 0; $i < $n; $i++) { $d = $arr[$i] - $mean; $sq += $d * $d; }
$var = $sq / $n;
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Mean: " . $mean . "
";
echo "Variance: " . $var . "
";
echo "Time: " . round($ms) . "ms
";
