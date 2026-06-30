<?php
$size = 300;
$m = []; $t = [];
for ($i = 0; $i < $size; $i++) {
    for ($j = 0; $j < $size; $j++) { $m[$i][$j] = $i + $j; $t[$i][$j] = 0; }
}
$start = hrtime(true);
for ($i = 0; $i < $size; $i++) {
    for ($j = 0; $j < $size; $j++) { $t[$j][$i] = $m[$i][$j]; }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "T[0][0]: " . $t[0][0] . "
";
echo "T[299][299]: " . $t[299][299] . "
";
echo "Time: " . round($ms) . "ms
";
