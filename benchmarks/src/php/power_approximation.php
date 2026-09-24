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
function add_big($a, $b) {
    $base = 1000000000;
    $n = max(count($a), count($b));
    $carry = 0;
    $result = [];
    for ($i = 0; $i < $n; $i++) {
        $sum = ($a[$i] ?? 0) + ($b[$i] ?? 0) + $carry;
        if ($sum >= $base) { $sum -= $base; $carry = 1; }
        else { $carry = 0; }
        $result[$i] = $sum;
    }
    if ($carry > 0) { $result[] = $carry; }
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
function power($base, $exp) {
    $result = [1];
    for ($i = 0; $i < $exp; $i++) { $result = mul_small($result, $base); }
    return $result;
}
$start = hrtime(true);
$sum = [0];
for ($i = 0; $i < 10000; $i++) { $sum = add_big($sum, power(2, 1000)); }
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Sum: " . big_to_string($sum) . "
";
echo "Time: " . round($ms) . "ms
";
