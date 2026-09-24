<?php
$seed = 12345;
function ri($m) { global $seed; $seed = ($seed * 16807) % 2147483647; return $seed % $m; }

function gen($depth) {
    if ($depth == 7) return ri(100000);
    $node = [];
    $node["a"] = ri(4) == 0 ? ri(100000) : gen($depth + 1);
    $node["b"] = ri(4) == 0 ? ri(100000) : gen($depth + 1);
    $node["c"] = ri(4) == 0 ? ri(100000) : gen($depth + 1);
    $node["s"] = "x" . ri(1000);
    return $node;
}

function count_nodes($node) {
    if (is_int($node) || is_string($node)) return 0;
    return 1 + count_nodes($node["a"]) + count_nodes($node["b"]) + count_nodes($node["c"]);
}

function serialize_node($node) {
    if (is_int($node)) return (string)$node;
    $parts = [];
    $parts[] = '{"a":';
    $parts[] = serialize_node($node["a"]);
    $parts[] = ',"b":';
    $parts[] = serialize_node($node["b"]);
    $parts[] = ',"c":';
    $parts[] = serialize_node($node["c"]);
    $parts[] = ',"s":"';
    $parts[] = $node["s"];
    $parts[] = '"}';
    return implode("", $parts);
}

$tree = gen(0);
$nc = count_nodes($tree);
$start = hrtime(true);
$total = 0;
for ($i = 0; $i < 50; $i++) $total += strlen(serialize_node($tree));
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . ($total % 1000003) . "_" . $nc . "\n";
echo "Time: " . round($ms) . "ms\n";
