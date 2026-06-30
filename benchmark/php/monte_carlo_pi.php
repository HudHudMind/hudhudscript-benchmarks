<?php
$inside = 0;
$total = 500000;
$seed = 12345;
function next_random() {
    global $seed;
    $seed = ($seed * 16807) % 2147483647;
    return $seed / 2147483647.0;
}
$start = hrtime(true);
for ($i = 0; $i < $total; $i++) {
    $x = next_random();
    $y = next_random();
    if ($x * $x + $y * $y <= 1.0) {
        $inside++;
    }
}
$end = hrtime(true);
$pi = 4.0 * $inside / $total;
$ms = ($end - $start) / 1e6;
echo "Pi: " . $pi . "\n";
echo "Time: " . round($ms) . "ms\n";
