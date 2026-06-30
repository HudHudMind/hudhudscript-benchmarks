<?php
function hanoi($n) {
    if ($n == 1) return 1;
    return hanoi($n - 1) + 1 + hanoi($n - 1);
}
$start = hrtime(true);
$moves = hanoi(20);
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Moves: " . $moves . "
";
echo "Time: " . round($ms) . "ms
";
