interp recursionlimit {} 50000

proc bottom_up_tree {depth} {
    if {$depth > 0} {
        return [list [bottom_up_tree [expr {$depth - 1}]] [bottom_up_tree [expr {$depth - 1}]]]
    } else {
        return {}
    }
}

proc item_check {tree} {
    if {[llength $tree] > 0} {
        return [expr {1 + [item_check [lindex $tree 0]] + [item_check [lindex $tree 1]]}]
    } else {
        return 1
    }
}

set start [clock milliseconds]
set max_depth 12
set min_depth 4
set stretch_depth [expr {$max_depth + 1}]

set stretch_tree [bottom_up_tree $stretch_depth]
set check [item_check $stretch_tree]

set long_lived_tree [bottom_up_tree $max_depth]

for {set depth $min_depth} {$depth <= $max_depth} {incr depth 2} {
    set iterations [expr {1 << ($max_depth - $depth + $min_depth)}]
    set check_sum 0
    for {set i 0} {$i < $iterations} {incr i} {
        set check_sum [expr {$check_sum + [item_check [bottom_up_tree $depth]]}]
    }
}

set long_lived_check [item_check $long_lived_tree]
set end [clock milliseconds]

puts "Result: ${check}_${long_lived_check}"
puts "Time: [expr {$end - $start}]ms"
