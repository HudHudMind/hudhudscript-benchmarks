<?php
$size = 150;
$a = []; $b = []; $c = [];
for ($i = 0; $i < $size; $i++) {
    $ra = []; $rb = []; $rc = [];
    for ($j = 0; $j < $size; $j++) {
        $ra[] = $i + $j; $rb[] = $i - $j; $rc[] = 0;
    }
    $a[] = $ra; $b[] = $rb; $c[] = $rc;
}
$start = hrtime(true);
for ($i = 0; $i < $size; $i++) {
    for ($j = 0; $j < $size; $j++) {
        $s = 0;
        for ($k = 0; $k < $size; $k++) { $s += $a[$i][$k] * $b[$k][$j]; }
        $c[$i][$j] = $s;
    }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result[0][0]: " . $c[0][0] . "
";
echo "Result[149][149]: " . $c[149][149] . "
";
echo "Time: " . round($ms) . "ms
";
