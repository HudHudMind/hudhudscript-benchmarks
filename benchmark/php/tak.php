<?php
function tak($x, $y, $z) {
    if ($y < $x) {
        return tak(
            tak($x - 1, $y, $z),
            tak($y - 1, $z, $x),
            tak($z - 1, $x, $y)
        );
    }
    return $z;
}

$start = microtime(true) * 1000;
$res = 0;
for ($i = 0; $i < 10; $i++) {
    $res = tak(18, 12, 6);
}
$end = microtime(true) * 1000;

echo "Result: " . $res . "\n";
echo "Time: " . round($end - $start) . "ms\n";
?>
