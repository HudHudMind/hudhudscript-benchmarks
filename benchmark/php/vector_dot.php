<?php
$a = []; $b = [];
for ($i = 0; $i < 500000; $i++) { $a[] = $i + 1; $b[] = $i + 2; }
$start = hrtime(true);
$sum = 0;
for ($i = 0; $i < 500000; $i++) { $sum += $a[$i] * $b[$i]; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Dot: " . $sum . "
";
echo "Time: " . round($ms) . "ms
";
