<?php
function gcd($a, $b) {
    while ($b != 0) {
        $t = $b; $b = $a % $b; $a = $t;
    }
    return $a;
}
$start = hrtime(true);
$result = 0;
for ($i = 1; $i <= 10000; $i++) {
    $result = gcd($i * 12345, $i * 6789 + 1);
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $result . "
";
echo "Time: " . round($ms) . "ms
";
