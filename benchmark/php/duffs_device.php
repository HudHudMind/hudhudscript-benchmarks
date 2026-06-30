<?php
function duffs_device($count) {
    $a = array_fill(0, $count, 0);
    $b = array_fill(0, $count, 1);
    
    $n = (int)($count / 8);
    $rem = $count % 8;
    $i = 0;
    
    while ($rem > 0) {
        $a[$i] = $b[$i];
        $i++;
        $rem--;
    }
    
    while ($n > 0) {
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $a[$i] = $b[$i]; $i++;
        $n--;
    }
    return $a[$count - 1];
}

$start = microtime(true) * 1000;
$res = 0;
for ($k = 0; $k < 100; $k++) {
    $res = duffs_device(100000);
}
$end = microtime(true) * 1000;

echo "Result: " . $res . "\n";
echo "Time: " . round($end - $start) . "ms\n";
?>
