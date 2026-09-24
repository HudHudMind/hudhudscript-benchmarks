<?php
function mul_small($a, $n) {
    $base = 1000000000;
    $carry = 0;
    $result = [];
    $count = count($a);
    for ($i = 0; $i < $count; $i++) {
        $prod = $a[$i] * $n + $carry;
        $result[$i] = $prod % $base;
        $carry = intdiv($prod, $base);
    }
    while ($carry > 0) {
        $result[] = $carry % $base;
        $carry = intdiv($carry, $base);
    }
    return $result;
}
function big_to_string($a) {
    $last = count($a) - 1;
    $result = strval($a[$last]);
    for ($i = $last - 1; $i >= 0; $i--) {
        $result .= str_pad(strval($a[$i]), 9, "0", STR_PAD_LEFT);
    }
    return $result;
}

$start = hrtime(true);
$result = [1];
$n = 10000;
while ($n > 1) { 
    $result = mul_small($result, $n);
    $n--; 
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . big_to_string($result) . "\n";
echo "Time: " . round($ms) . "ms\n";
