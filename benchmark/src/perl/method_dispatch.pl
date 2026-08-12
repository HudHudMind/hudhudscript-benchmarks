use Time::HiRes qw(time);

package Shape {
    sub score { return 0; }
}

package A {
    our @ISA = qw(Shape);
    sub new { my $class = shift; my $self = {v => 0}; bless $self, $class; return $self; }
    sub score { my $self = shift; return $self->{v} * 2; }
}

package B {
    our @ISA = qw(Shape);
    sub new { my $class = shift; my $self = {v => 0}; bless $self, $class; return $self; }
    sub score { my $self = shift; return $self->{v} * 3 + 1; }
}

package C {
    our @ISA = qw(Shape);
    sub new { my $class = shift; my $self = {v => 0}; bless $self, $class; return $self; }
    sub score { my $self = shift; return $self->{v} * 5 - 2; }
}

package main;

my @shapes;
for (my $i = 0; $i < 3000; $i++) {
    my $r = $i % 3;
    my $obj;
    if ($r == 0) { $obj = A->new(); }
    elsif ($r == 1) { $obj = B->new(); }
    else { $obj = C->new(); }
    $obj->{v} = $i % 97;
    push @shapes, $obj;
}

my $P = 300;
my $acc = 0;
my $start = time();
for (my $round = 0; $round < $P; $round++) {
    for my $s (@shapes) {
        $acc = ($acc + $s->score()) % 1000003;
    }
}
my $end = time();
my $ms = ($end - $start) * 1000;
print "Result: $acc\n";
printf "Time: %.0fms\n", $ms;
