<?php
function mandelbrot($size) {
    $sum_iters = 0;
    for ($y = 0; $y < $size; $y++) {
        for ($x = 0; $x < $size; $x++) {
            $zr = 0.0; $zi = 0.0;
            $cr = (2.0 * $x / $size) - 1.5;
            $ci = (2.0 * $y / $size) - 1.0;
            $escape = 0;
            for ($i = 0; $i < 50; $i++) {
                $tr = $zr * $zr - $zi * $zi + $cr;
                $ti = 2.0 * $zr * $zi + $ci;
                $zr = $tr;
                $zi = $ti;
                if ($zr * $zr + $zi * $zi > 4.0) {
                    $escape = 1;
                    break;
                }
            }
            $sum_iters += $escape;
        }
    }
    return $sum_iters;
}

$start = microtime(true) * 1000;
$res = mandelbrot(500);
$end = microtime(true) * 1000;

echo "Sum: " . $res . "\n";
echo "Time: " . round($end - $start) . "ms\n";
?>
