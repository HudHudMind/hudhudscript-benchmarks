<?php
function add_big($a, $b) {
    $base = 1000000000;
    $n = max(count($a), count($b));
    $carry = 0;
    $result = [];
    for ($i = 0; $i < $n; $i++) {
        $sum = ($a[$i] ?? 0) + ($b[$i] ?? 0) + $carry;
        if ($sum >= $base) {
            $sum -= $base;
            $carry = 1;
        } else {
            $carry = 0;
        }
        $result[$i] = $sum;
    }
    if ($carry > 0) {
        $result[] = $carry;
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
function fib_memo($n, &$memo) {
    if (isset($memo[$n])) return $memo[$n];
    $memo[$n] = add_big(fib_memo($n - 1, $memo), fib_memo($n - 2, $memo));
    return $memo[$n];
}
$start = hrtime(true);
$s = [0];
for ($i = 0; $i < 10000; $i++) {
    $memo = [0 => [0], 1 => [1]];
    $s = add_big($s, fib_memo(500, $memo));
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Sum: " . big_to_string($s) . "
";
echo "Time: " . round($ms) . "ms
";
