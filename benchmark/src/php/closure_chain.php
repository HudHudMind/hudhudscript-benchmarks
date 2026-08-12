<?php
function make_counter($start) {
    $c = $start;
    return function() use (&$c) {
        $c = $c + 1;
        return $c;
    };
}

$N = 150000;
$acc = 0;
$start = hrtime(true);
for ($i = 0; $i < $N; $i++) {
    $ctr = make_counter($i % 1000);
    $acc = ($acc + $ctr() + $ctr() + $ctr()) % 1000003;
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $acc . "\n";
echo "Time: " . round($ms) . "ms\n";
