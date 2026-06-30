<?php
function sqrt_newton($n) {
    if ($n == 0) return 0;
    $x = $n / 2;
    for ($i = 0; $i < 20; $i++) { $x = ($x + $n / $x) / 2; }
    return $x;
}
$start = hrtime(true);
$sum = 0;
for ($i = 1; $i <= 10000; $i++) { $sum += sqrt_newton($i); }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Sum: " . $sum . "
";
echo "Time: " . round($ms) . "ms
";
