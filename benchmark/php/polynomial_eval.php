<?php
$coeffs = [];
for ($i = 0; $i <= 1000; $i++) { $coeffs[] = $i + 1; }
function horner($coeffs, $x) {
    $result = $coeffs[1000];
    for ($i = 999; $i >= 0; $i--) {
        $result = $result * $x + $coeffs[$i];
    }
    return $result;
}
$start = hrtime(true);
$sum = 0;
for ($k = 0; $k < 100000; $k++) {
    $sum += horner($coeffs, 1.5);
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Sum: " . $sum . "
";
echo "Time: " . round($ms) . "ms
";
