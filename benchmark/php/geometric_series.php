<?php
$r = 0.999; $sum = 0; $term = 1;
$start = hrtime(true);
for ($i = 0; $i < 1000000; $i++) { $sum += $term; $term *= $r; }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Sum: " . $sum . "
";
echo "Time: " . round($ms) . "ms
";
