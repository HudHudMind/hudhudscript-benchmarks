<?php
function eval_A($i, $j) {
    return 1.0 / ((($i + $j) * ($i + $j + 1) / 2) + $i + 1);
}

function eval_A_times_u($u, &$v, $n) {
    for ($i = 0; $i < $n; $i++) {
        $v[$i] = 0.0;
        for ($j = 0; $j < $n; $j++) {
            $v[$i] += eval_A($i, $j) * $u[$j];
        }
    }
}

function eval_At_times_u($u, &$v, $n) {
    for ($i = 0; $i < $n; $i++) {
        $v[$i] = 0.0;
        for ($j = 0; $j < $n; $j++) {
            $v[$i] += eval_A($j, $i) * $u[$j];
        }
    }
}

function eval_AtA_times_u($u, &$v, &$w, $n) {
    eval_A_times_u($u, $w, $n);
    eval_At_times_u($w, $v, $n);
}

$start = microtime(true);
$n = 150;
$u = array_fill(0, $n, 1.0);
$v = array_fill(0, $n, 0.0);
$w = array_fill(0, $n, 0.0);

for ($i = 0; $i < 10; $i++) {
    eval_AtA_times_u($u, $v, $w, $n);
    eval_AtA_times_u($v, $u, $w, $n);
}

$vBv = 0.0;
$vv = 0.0;
for ($i = 0; $i < $n; $i++) {
    $vBv += $u[$i] * $v[$i];
    $vv += $v[$i] * $v[$i];
}

$res = sqrt($vBv / $vv);
$end = microtime(true);

printf("Result: %.9f\n", $res);
printf("Time: %dms\n", ($end - $start) * 1000);
