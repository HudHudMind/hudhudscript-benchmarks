<?php
// Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
// Pure PHP limb bignum base 10^9, D=600. Golden: 2668_6766940513

define('BASE', 1000000000);
define('D', 600);
define('MAXL', D + 10);

// Big number as array [n=>limb_count, d=>limb_array]
function big_new($x = 0) {
    $b = ['n' => 0, 'd' => array_fill(0, MAXL, 0)];
    while ($x > 0) {
        $b['d'][$b['n']++] = $x % BASE;
        $x = intdiv($x, BASE);
    }
    if ($b['n'] == 0) { $b['n'] = 1; }
    return $b;
}

function big_zero() { $b = ['n' => 1, 'd' => array_fill(0, MAXL, 0)]; return $b; }

function big_copy($src) {
    $b = ['n' => $src['n'], 'd' => array_fill(0, MAXL, 0)];
    for ($i = 0; $i < $src['n']; $i++) $b['d'][$i] = $src['d'][$i];
    return $b;
}

// dst = a + b
function add_into($a, $b, &$dst) {
    $c = 0; $n = max($a['n'], $b['n']);
    for ($i = 0; $i < $n; $i++) {
        $v = ($a['d'][$i] ?? 0) + ($b['d'][$i] ?? 0) + $c;
        if ($v >= BASE) { $v -= BASE; $c = 1; } else { $c = 0; }
        $dst['d'][$i] = $v;
    }
    if ($c > 0) { $dst['d'][$n++] = $c; }
    $dst['n'] = $n;
}

// dst = a - b (a >= b)
function sub_into($a, $b, &$dst) {
    $bo = 0; $n = $a['n'];
    for ($i = 0; $i < $a['n']; $i++) {
        $v = $a['d'][$i] - ($b['d'][$i] ?? 0) - $bo;
        if ($v < 0) { $v += BASE; $bo = 1; } else { $bo = 0; }
        $dst['d'][$i] = $v;
    }
    while ($n > 1 && $dst['d'][$n - 1] == 0) $n--;
    $dst['n'] = $n;
}

// dst = a * s (s < BASE)
function muls_into($a, $s, &$dst) {
    $c = 0; $n = $a['n'];
    for ($i = 0; $i < $n; $i++) {
        $v = $a['d'][$i] * $s + $c;
        $c = intdiv($v, BASE);
        $dst['d'][$i] = $v - $c * BASE;
    }
    while ($c > 0) {
        $dst['d'][$n++] = $c % BASE;
        $c = intdiv($c, BASE);
    }
    $dst['n'] = $n;
}

// (q, rem) = a // s, q written to dst, returns remainder
function divs_into($a, $s, &$dst) {
    $rem = 0;
    $tmp = [];
    $qn = 0;
    for ($i = $a['n'] - 1; $i >= 0; $i--) {
        $rem = $rem * BASE + $a['d'][$i];
        $qd = intdiv($rem, $s);
        $rem -= $qd * $s;
        $tmp[$qn++] = $qd;
    }
    for ($i = 0; $i < $qn; $i++) {
        $dst['d'][$i] = $tmp[$qn - 1 - $i];
    }
    $n = $qn;
    while ($n > 1 && $dst['d'][$n - 1] == 0) $n--;
    $dst['n'] = $n;
    return $rem;
}

function big_to_str($a) {
    if ($a['n'] == 1 && $a['d'][0] == 0) return "0";
    $parts = [];
    $tmp = big_copy($a);
    while ($tmp['n'] > 1 || $tmp['d'][0] > 0) {
        $rem = divs_into($tmp, BASE, $tmp);
        $parts[] = sprintf("%09d", $rem);
    }
    $s = implode("", array_reverse($parts));
    $s = ltrim($s, "0");
    return $s === "" ? "0" : $s;
}

// ── arctan(1/x) to $digits decimal places ──────────────────────
function arctan_inv($x, $digits) {
    $GUARD = 5;
    $SCALE = $digits + $GUARD;

    $res = big_zero();

    // term = 10^SCALE / x
    $term = big_new(1);
    for ($i = 0; $i < $SCALE; $i++) {
        $t2 = big_zero();
        muls_into($term, 10, $t2);
        $term = $t2;
    }
    $t2 = big_zero();
    divs_into($term, $x, $t2);
    $term = $t2;

    $x2 = $x * $x;
    $sign = 1;
    $max_iter = ($digits + $GUARD) * 3 + 20;

    for ($k = 0; $k < $max_iter; $k++) {
        $divisor = 2 * $k + 1;

        $tdiv = big_zero();
        divs_into($term, $divisor, $tdiv);

        $is_zero = true;
        for ($i = 0; $i < $tdiv['n']; $i++) {
            if ($tdiv['d'][$i] != 0) { $is_zero = false; break; }
        }
        if ($is_zero) break;

        if ($sign > 0) {
            $tmp = big_zero();
            add_into($res, $tdiv, $tmp);
            $res = $tmp;
        } else {
            $tmp = big_zero();
            sub_into($res, $tdiv, $tmp);
            $res = $tmp;
        }

        $sign = -$sign;

        $next_term = big_zero();
        divs_into($term, $x2, $next_term);
        $term = $next_term;
    }

    return $res;
}

// ── Main ───────────────────────────────────────────────────────
$start = hrtime(true);

$a5 = arctan_inv(5, D + 5);
$a239 = arctan_inv(239, D + 5);

$tmp1 = big_zero(); $tmp2 = big_zero(); $tmp3 = big_zero();
muls_into($a5, 16, $tmp1);
muls_into($a239, 4, $tmp2);
sub_into($tmp1, $tmp2, $tmp3);

$pi_str = big_to_str($tmp3);
$pi_str = str_pad($pi_str, D + 10, "0", STR_PAD_LEFT);
$pi_str = substr($pi_str, 0, D);

$ds = 0;
for ($i = 0; $i < D; $i++) $ds += (int)$pi_str[$i];
$lt = substr($pi_str, D - 10);

$end = hrtime(true);
$ms = ($end - $start) / 1e6;
echo "Result: {$ds}_{$lt}\n";
echo "Time: " . round($ms) . "ms\n";
