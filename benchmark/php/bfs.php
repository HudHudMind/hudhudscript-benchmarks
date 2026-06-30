<?php
$n = 100;
$adj = [];
for ($i = 0; $i < $n; $i++) {
    $row = [];
    for ($j = 0; $j < $n; $j++) {
        $row[] = (($i * 3 + $j * 7) % 11 == 0 && $i != $j) ? 1 : 0;
    }
    $adj[] = $row;
}
$start = hrtime(true);
$visited = array_fill(0, $n, false);
$queue = [0];
$head = 0;
$count = 0;
while ($head < count($queue)) {
    $node = $queue[$head];
    $head++;
    if (!$visited[$node]) {
        $visited[$node] = true;
        $count++;
        for ($neighbor = 0; $neighbor < $n; $neighbor++) {
            if ($adj[$node][$neighbor] == 1 && !$visited[$neighbor]) {
                $queue[] = $neighbor;
            }
        }
    }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Visited: " . $count . "
";
echo "Time: " . round($ms) . "ms
";
