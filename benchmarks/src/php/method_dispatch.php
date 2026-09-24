<?php
class Shape { function score() { return 0; } }
class A extends Shape { public $v = 0; function score() { return $this->v * 2; } }
class B extends Shape { public $v = 0; function score() { return $this->v * 3 + 1; } }
class C extends Shape { public $v = 0; function score() { return $this->v * 5 - 2; } }

$shapes = [];
for ($i = 0; $i < 3000; $i++) {
    $r = $i % 3;
    if ($r == 0) $obj = new A();
    elseif ($r == 1) $obj = new B();
    else $obj = new C();
    $obj->v = $i % 97;
    $shapes[] = $obj;
}

$P = 300;
$acc = 0;
$start = hrtime(true);
for ($round = 0; $round < $P; $round++) {
    foreach ($shapes as $s) {
        $acc = ($acc + $s->score()) % 1000003;
    }
}
$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: " . $acc . "\n";
echo "Time: " . round($ms) . "ms\n";
