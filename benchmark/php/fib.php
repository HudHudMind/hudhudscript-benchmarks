<?php
function fib($n) {
    if ($n <= 1) return $n;
    return fib($n - 1) + fib($n - 2);
}
$start = hrtime(true);
$result = fib(30);
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "fib(30) = " . $result . "
";
echo "Time: " . round($ms) . "ms
";
