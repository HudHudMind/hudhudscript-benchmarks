class Shape { method score { return 0 } }
class A is Shape { has $.v is rw = 0; method score { return $!v * 2 } }
class B is Shape { has $.v is rw = 0; method score { return $!v * 3 + 1 } }
class C is Shape { has $.v is rw = 0; method score { return $!v * 5 - 2 } }

my @shapes;
for 0..2999 -> $i {
    my $r = $i % 3;
    my $obj = $r == 0 ?? A.new !! $r == 1 ?? B.new !! C.new;
    $obj.v = $i % 97;
    @shapes.push($obj);
}

my $P = 300;
my $acc = 0;
my $start = now * 1000;
for ^$P {
    for @shapes -> $s {
        $acc = ($acc + $s.score) % 1000003;
    }
}
my $end = now * 1000;
say "Result: " ~ $acc;
say "Time: " ~ ($end - $start).Int ~ "ms";
