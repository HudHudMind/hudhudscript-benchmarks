# n_queens: board[row]=col, linear safety scan, iterative backtracking
set n 8
set board {}
for {set i 0} {$i < $n} {incr i} {lappend board -1}
set sols 0
set row 0
set start [clock milliseconds]

while {$row >= 0} {
    if {$row == $n} {
        incr sols
        incr row -1
        continue
    }
    # Try next column for current row
    set col [expr {[lindex $board $row] + 1}]
    lset board $row -1
    if {$col >= $n} {
        incr row -1
        continue
    }
    # Linear safety scan against placed rows
    set safe 1
    for {set r 0} {$r < $row} {incr r} {
        set bc [lindex $board $r]
        if {$bc == $col || [expr {abs($bc - $col)}] == [expr {$row - $r}]} {
            set safe 0
            break
        }
    }
    if {$safe} {
        lset board $row $col
        incr row
    } else {
        # Try next column in same row
        lset board $row $col
    }
}

set end [clock milliseconds]
puts "Result: $sols"
puts "Time: [expr {$end - $start}]ms"
