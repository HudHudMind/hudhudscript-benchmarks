<?php
function mul_small($a, $n) {
    $base = 1000000000;
    $carry = 0;
    $result = [];
    for ($i = 0; $i < count($a); $i++) {
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
function fact($n) {
    if ($n <= 1) return [1];
    return mul_small(fact($n - 1), $n);
}
$start = hrtime(true);
$result = fact(150);
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "fact(150) = " . big_to_string($result) . "
";
echo "Time: " . round($ms) . "ms
";
