<?php
$sum = 0;
$start = hrtime(true);
for ($i = 1; $i <= 1000000; $i++) { $sum += $i * $i; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Sum: " . $sum . "
";
echo "Time: " . round($ms) . "ms
";
