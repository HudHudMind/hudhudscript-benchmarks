<?php
function ack($m, $n) {
    if ($m == 0) return $n + 1;
    if ($n == 0) return ack($m - 1, 1);
    return ack($m - 1, ack($m, $n - 1));
}
$start = hrtime(true);
$result = ack(3, 6);
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $result . "
";
echo "Time: " . round($ms) . "ms
";
