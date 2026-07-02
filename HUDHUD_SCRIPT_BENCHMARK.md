# Inside the HudHudScript Benchmark Suite: All 50 Programs Explained

An elapsed-time number means very little until we know what produced it. A runtime may be quick at recursive calls but slow at string construction; it may excel at dense arithmetic while paying heavily for allocation. The HudHudScript benchmark suite was built around that reality. Instead of relying on one oversized synthetic test, it uses 50 programs that place pressure on different parts of a language implementation.

The collection begins with basic runtime mechanics—loops, calls, branches, arrays, strings, and arithmetic—and extends into graph traversal, dynamic programming, scientific computing, bioinformatics, sorting, and number theory. Several implementations are intentionally straightforward. Replacing the sum-of-squares loop with a formula, for example, would produce the same answer but would no longer measure a million multiplications and additions.

Timing boundaries are visible in every listing. Data preparation sits outside the timed interval when the source places `Date.to_millis()` after setup; allocation or generation remains inside when it is part of the workload itself. The benchmark runner adds external timing and output validation, but the embedded timer documents which region each program was designed to exercise.

Every code block below is the complete HudHudScript source from `benchmarks/src/hudhud`. These are neither shortened examples nor reconstructed pseudocode.

> **Integer Division Note:** Several algorithms in this suite (such as Binary Search, Collatz, Heap Sort, Modular Exponentiation, and K-Nucleotide) assume that the `/` operator performs exact integer division (floor division) when given two integers. In HudHudScript, this is the default behavior. For comparisons against languages that return floating-point numbers (like JavaScript or standard Lua), implementations must explicitly use `Math.floor` or equivalent to maintain algorithmic parity.

## The suite at a glance

| # | Benchmark | Area | What it puts under pressure |
|---:|---|---|---|
| 1 | [Ackermann Function](#01-ack) | Recursion | A dense tree of tiny recursive calls |
| 2 | [Array Summation](#02-arrsum) | Arrays | Sequential indexed reads and integer accumulation |
| 3 | [Breadth-First Search](#03-bfs) | Graphs | A queue-driven traversal of an adjacency matrix |
| 4 | [Binary Trees](#04-binary-trees) | Allocation | Rapid allocation and traversal of short-lived trees |
| 5 | [Binary Search](#05-bsearch) | Search | Ten thousand branch-dependent logarithmic searches |
| 6 | [Bubble Sort](#06-bubble) | Sorting | Quadratic comparisons and swaps on reverse input |
| 7 | [Collatz Sequences](#07-collatz) | Integer control flow | Irregular loops driven by parity and sequence length |
| 8 | [Count Set Bits](#08-count-set-bits) | Integer arithmetic | Portable bit counting through division and remainder |
| 9 | [Cumulative Sum](#09-cumulative-sum) | Arrays | A sequential read-and-append prefix scan |
| 10 | [Depth-First Search](#10-dfs) | Graphs | Explicit-stack graph traversal |
| 11 | [Duff's Device-Style Copy](#11-duffs-device) | Loop unrolling | Eight assignments per loop-control decision |
| 12 | [Iterative Factorial](#12-fact) | BigInt | Progressively larger arbitrary-precision multiplication |
| 13 | [Recursive Factorial](#13-factorial-recursive) | BigInt / recursion | Large integers travelling through recursive returns |
| 14 | [Fannkuch Redux](#14-fannkuch-redux) | Permutations | Branch-heavy permutation generation and prefix flips |
| 15 | [FASTA Generation](#15-fasta) | Strings / random | Deterministic weighted DNA-like sequence construction |
| 16 | [Recursive Fibonacci](#16-fib) | Recursion | An exponential tree of minimal function calls |
| 17 | [Iterative Fibonacci](#17-fib-iterative) | BigInt | Predictable loops over exact 209-digit values |
| 18 | [Fibonacci Table Construction](#18-fib-memo) | BigInt / arrays | Repeated construction of BigInt lookup tables |
| 19 | [Euclidean Greatest Common Divisor](#19-gcd) | Integer arithmetic | Short, data-dependent modulo loops |
| 20 | [Geometric Series](#20-geometric-series) | Floating point | One million dependent multiply-and-add steps |
| 21 | [Tower of Hanoi](#21-hanoi) | Recursion | A full binary recursive call tree |
| 22 | [Heap Sort](#22-heap-sort) | Sorting | Irregular parent-and-child array access |
| 23 | [Insertion Sort](#23-insertion-sort) | Sorting | Worst-case backward shifting through an array |
| 24 | [K-Nucleotide Frequencies](#24-k-nucleotide) | Strings / bioinformatics | Overlapping DNA windows encoded into fixed arrays |
| 25 | [0/1 Knapsack](#25-knapsack) | Dynamic programming | A dense two-dimensional optimization table |
| 26 | [Longest Common Subsequence](#26-lcs) | Dynamic programming | Character comparisons across a 101-by-101 table |
| 27 | [Mandelbrot Set](#27-mandelbrot) | Floating point | A quarter-million escape-time calculations |
| 28 | [Matrix Multiplication](#28-matrix) | Linear algebra | A dense three-level multiply-accumulate kernel |
| 29 | [Matrix Transpose](#29-matrix-transpose) | Arrays | Opposing read and write directions in a matrix |
| 30 | [Mean and Variance](#30-mean-variance) | Statistics | Two full floating-point passes over a million values |
| 31 | [Merge Sort](#31-merge) | Sorting | Bottom-up merging with temporary arrays |
| 32 | [Modular Exponentiation](#32-modular-exp) | Integer arithmetic | Exponentiation by squaring under a fixed modulus |
| 33 | [Monte Carlo Pi](#33-monte-carlo-pi) | Random / floating point | Half a million deterministic point-in-circle tests |
| 34 | [N-Body Simulation](#34-n-body) | Scientific computing | Ten thousand dependent gravitational updates |
| 35 | [Eight Queens](#35-n-queens) | Backtracking | An iterative search through constrained placements |
| 36 | [Newton Square Roots](#36-newton-sqrt) | Floating point | Two hundred thousand division-heavy refinement steps |
| 37 | [Palindrome Check](#37-palindrome) | Strings | Repeated full scans from both ends of a string |
| 38 | [Polynomial Evaluation](#38-polynomial-eval) | Floating point | A long dependent chain of multiply-add operations |
| 39 | [Repeated Power](#39-power) | BigInt | Exact 301-digit powers accumulated ten thousand times |
| 40 | [Prime Count by Trial Division](#40-prime-count) | Number theory | Data-dependent divisor scans with many early exits |
| 41 | [Iterative Quick Sort](#41-quick) | Sorting | Partitioning plus an explicit range stack |
| 42 | [Reverse Complement](#42-revcomp) | Strings / bioinformatics | Ten reverse scans through a 500,000-character sequence |
| 43 | [Sieve of Eratosthenes](#43-sieve) | Number theory | Repeated marking through a boolean array |
| 44 | [Spectral Norm](#44-spectral-norm) | Linear algebra | Power iteration over an implicit floating-point matrix |
| 45 | [String Concatenation](#45-strcat) | Strings | Fifty thousand incremental string appends |
| 46 | [String Reverse](#46-strrev) | Strings | Reverse indexing followed by one array join |
| 47 | [Naive Substring Search](#47-substring-search) | Strings | A sliding window with short character-by-character checks |
| 48 | [Sum of Squares](#48-sum-of-squares) | Wide/exact integer | One million exact multiplications and additions |
| 49 | [Takeuchi Function](#49-tak) | Recursion | Deeply nested recursive argument evaluation |
| 50 | [Vector Dot Product](#50-vector-dot) | Wide/exact integer | Two indexed reads and one multiply-add per element |

## The programs

The categories in the table are signposts, not rigid boundaries. `fib_iterative` is both a loop benchmark and a BigInt benchmark; `binary_trees` combines recursion with intensive allocation. Each explanation therefore describes the algorithm first and then identifies the runtime behavior that gives the result its meaning.

<a id="01-ack"></a>
## 1. Ackermann Function (`ack`)

**Area:** Recursion

Ackermann's function grows so quickly that even small inputs create a formidable call tree. We evaluate `ack(3, 6)`, whose recursive case can invoke Ackermann again while calculating an argument for the next call. There is almost no work to hide behind: comparisons, subtraction, calls, and returns account for nearly all of the running time. That makes this program a sharp test of call-frame creation, nested return values, and the cost of recursion in the interpreter or VM.

Source: `benchmarks/src/hudhud/ack.hud`

```hudhud
fn ack(m, n) {
    if (m == 0) {
        return n + 1;
    }
    if (n == 0) {
        return ack(m - 1, 1);
    }
    return ack(m - 1, ack(m, n - 1));
}
let start = Date.to_millis();
let result = ack(3, 6);
let end = Date.to_millis();
print("Result: " + result);
print("Time: " + (end - start) + "ms");
```

<a id="02-arrsum"></a>
## 2. Array Summation (`arrsum`)

**Area:** Arrays

First, the program builds an array containing the integers from zero to 9,999. The timed portion then walks the array once and adds every value to a single accumulator. This is an intentionally plain baseline. It shows the cost of indexed array access, bounds checks, loop dispatch, integer addition, and repeated assignment without mixing in a more elaborate algorithm.

Source: `benchmarks/src/hudhud/arrsum.hud`

```hudhud
let arr = [];
for (let i = 0; i < 10000; i = i + 1) {
    arr.push(i);
}
let sum = 0;
let start = Date.to_millis();
for (let i = 0; i < 10000; i = i + 1) {
    sum = sum + arr[i];
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="03-bfs"></a>
## 3. Breadth-First Search (`bfs`)

**Area:** Graphs

This program constructs a deterministic graph of 100 vertices as an adjacency matrix, then performs breadth-first search from vertex zero. The queue uses a moving head index, so removing the next item does not require shifting the array. Every visited vertex triggers a scan across one matrix row. The result combines queue growth, nested indexing, boolean state, and branch-heavy neighbor checks in a recognizable graph workload.

Source: `benchmarks/src/hudhud/bfs.hud`

```hudhud
let adj = [];
let i = 0;
let row = [];
let j = 0;
while (i < 100) {
    row = [];
    j = 0;
    while (j < 100) {
        row.push(0);
        j = j + 1;
    }
    adj.push(row);
    i = i + 1;
}
i = 0;
while (i < 100) {
    j = 0;
    while (j < 100) {
        if ((i * 3 + j * 7) % 11 == 0 && i != j) {
            adj[i][j] = 1;
        }
        j = j + 1;
    }
    i = i + 1;
}
let start = Date.to_millis();
let visited = [];
i = 0;
while (i < 100) {
    visited.push(false);
    i = i + 1;
}
let queue = [];
queue.push(0);
let head = 0;
let count = 0;
let node = 0;
let neighbor = 0;
while (head < queue.length) {
    node = queue[head];
    head = head + 1;
    if (!visited[node]) {
        visited[node] = true;
        count = count + 1;
        neighbor = 0;
        while (neighbor < 100) {
            if (adj[node][neighbor] == 1 && !visited[neighbor]) {
                queue.push(neighbor);
            }
            neighbor = neighbor + 1;
        }
    }
}
let end = Date.to_millis();
print("Visited: " + count);
print("Time: " + (end - start) + "ms");
```

<a id="04-binary-trees"></a>
## 4. Binary Trees (`binary_trees`)

**Area:** Allocation

The binary-trees benchmark creates a stretch tree, batches of temporary trees at several depths, and a long-lived tree. It recursively checks the number of nodes in each structure. Most nodes live only briefly, while one tree remains reachable for the duration of the test. The resulting mix is designed to expose recursive construction and traversal, small-array allocation, garbage collection, and the runtime's handling of objects with very different lifetimes.


> **Note:** The algorithm intentionally calculates a `check_sum` that is never printed. This forces the interpreter to do the work without allowing future JIT compilers to easily eliminate it as dead code.

Source: `benchmarks/src/hudhud/binary_trees.hud`

```hudhud
fn bottom_up_tree(depth) {
    if (depth > 0) {
        return [bottom_up_tree(depth - 1), bottom_up_tree(depth - 1)];
    } else {
        return [];
    }
}

fn item_check(tree) {
    if (tree.length > 0) {
        return 1 + item_check(tree[0]) + item_check(tree[1]);
    } else {
        return 1;
    }
}

let start = Date.to_millis();
let max_depth = 12;
let min_depth = 4;
let stretch_depth = max_depth + 1;

let stretch_tree = bottom_up_tree(stretch_depth);
let check = item_check(stretch_tree);

let long_lived_tree = bottom_up_tree(max_depth);

let depth = min_depth;
while (depth <= max_depth) {
    let iterations = 1;
    let shift = max_depth - depth + min_depth;
    let s = 0;
    while (s < shift) {
        iterations = iterations * 2;
        s = s + 1;
    }
    
    let check_sum = 0;
    let i = 0;
    while (i < iterations) {
        check_sum = check_sum + item_check(bottom_up_tree(depth));
        i = i + 1;
    }
    depth = depth + 2;
}

let long_lived_check = item_check(long_lived_tree);
let end = Date.to_millis();

print("Result: " + check + "_" + long_lived_check);
print("Time: " + (end - start) + "ms");
```

<a id="05-bsearch"></a>
## 5. Binary Search (`bsearch`)

**Area:** Search

A sorted array holds 100,000 even numbers. The timed section performs 10,000 binary searches for deterministic targets, halving the remaining interval after every comparison. Although each query touches relatively few elements, every next index depends on the previous branch. The benchmark therefore concentrates on indexed reads, integer division, comparisons, and short data-dependent loops rather than bulk sequential scanning.

Source: `benchmarks/src/hudhud/bsearch.hud`

```hudhud
let arr = [];
for (let i = 0; i < 100000; i = i + 1) {
    arr.push(i * 2);
}
let start = Date.to_millis();
let found = 0;
for (let j = 0; j < 10000; j = j + 1) {
    let target = j * 20;
    let left = 0;
    let right = 99999;
    while (left <= right) {
        let mid = (left + right) / 2;
        let mid_val = arr[mid];
        if (mid_val == target) {
            found = found + 1;
            break;
        }
        if (mid_val < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
}
let end = Date.to_millis();
print("Found: " + found);
print("Time: " + (end - start) + "ms");
```

<a id="06-bubble"></a>
## 6. Bubble Sort (`bubble`)

**Area:** Sorting

Bubble sort repeatedly compares adjacent elements and exchanges those that are out of order. Here, 500 integers begin in descending order, which forces the algorithm into its quadratic worst-case pattern. The program spends its time in two nested loops performing array reads, branches, temporary assignments, and writes. It is deliberately unsophisticated because those fundamental operations are exactly what this test is intended to reveal.

Source: `benchmarks/src/hudhud/bubble.hud`

```hudhud
let n = 500;
let arr = [];
for (let i = n; i > 0; i = i - 1) {
    arr.push(i);
}
let start = Date.to_millis();
for (let k = 0; k < n; k = k + 1) {
    for (let j = 0; j < n - 1; j = j + 1) {
        if (arr[j] > arr[j + 1]) {
            let temp = arr[j];
            arr[j] = arr[j + 1];
            arr[j + 1] = temp;
        }
    }
}
let end = Date.to_millis();
print("First: " + arr[0]);
print("Last: " + arr[n - 1]);
print("Time: " + (end - start) + "ms");
```

<a id="07-collatz"></a>
## 7. Collatz Sequences (`collatz`)

**Area:** Integer control flow

For every starting value from one through 10,000, the program follows the Collatz rule until the sequence reaches one. Even values are halved; odd values become `3n + 1`. It records which starting value takes the most steps. Sequence lengths vary widely, so the inner loop cannot settle into one fixed pattern. Modulo, division, multiplication, branching, and data-dependent termination all remain active throughout the run.

Source: `benchmarks/src/hudhud/collatz.hud`

```hudhud
let start = Date.to_millis();
let max_steps = 0;
let max_n = 0;
for (let n = 1; n <= 10000; n = n + 1) {
    let steps = 0;
    let current = n;
    while (current != 1) {
        if (current % 2 == 0) {
            current = current / 2;
        } else {
            current = current * 3 + 1;
        }
        steps = steps + 1;
    }
    if (steps > max_steps) {
        max_steps = steps;
        max_n = n;
    }
}
let end = Date.to_millis();
print("Max steps: " + max_steps + " at n=" + max_n);
print("Time: " + (end - start) + "ms");
```

<a id="08-count-set-bits"></a>
## 8. Count Set Bits (`count_set_bits`)

**Area:** Integer arithmetic

The program counts all one-bits in the binary forms of the integers from one through 100,000. Instead of calling a population-count intrinsic, it repeatedly tests `x % 2` and divides `x` by two. That choice keeps the benchmark comparable at the language level and makes its costs visible: nested loops, integer remainder and division, conditional increments, and conversion toward the terminating value of zero.

Source: `benchmarks/src/hudhud/count_set_bits.hud`

```hudhud
let start = Date.to_millis();
let total = 0;
for (let n = 1; n <= 100000; n = n + 1) {
    let x = n;
    while (x > 0) {
        if (x % 2 == 1) {
            total = total + 1;
        }
        x = x / 2;
    }
}
let end = Date.to_millis();
print("Total: " + total);
print("Time: " + (end - start) + "ms");
```

<a id="09-cumulative-sum"></a>
## 9. Cumulative Sum (`cumulative_sum`)

**Area:** Arrays

An input array contains the integers from one through 100,000. The timed loop maintains a running total and appends that total to a second array after reading each input element. Compared with ordinary summation, this version adds one growing output structure and one write per iteration. It measures sequential array access, arithmetic, allocation, capacity growth, and the cost of storing every intermediate result.

Source: `benchmarks/src/hudhud/cumulative_sum.hud`

```hudhud
let n = 100000;
let arr = [];
for (let i = 1; i <= n; i = i + 1) {
    arr.push(i);
}
let start = Date.to_millis();
let cum = [];
let s = 0;
for (let i = 0; i < n; i = i + 1) {
    s = s + arr[i];
    cum.push(s);
}
let end = Date.to_millis();
print("Last: " + cum[n - 1]);
print("Time: " + (end - start) + "ms");
```

<a id="10-dfs"></a>
## 10. Depth-First Search (`dfs`)

**Area:** Graphs

Depth-first search traverses a deterministic 100-vertex adjacency matrix from vertex zero. Rather than using recursive calls, the implementation stores pending vertices in an explicit stack and considers neighbors in reverse index order. The workload brings together push and pop operations, nested array access, visitation checks, and irregular control flow. Read beside BFS, it also shows how stack and queue frontier strategies behave over comparable graph data.

Source: `benchmarks/src/hudhud/dfs.hud`

```hudhud
let n = 100;
let adj = [];
for (let i = 0; i < n; i = i + 1) {
    let row = [];
    for (let j = 0; j < n; j = j + 1) {
        row.push(0);
    }
    adj.push(row);
}
for (let i = 0; i < n; i = i + 1) {
    for (let j = 0; j < n; j = j + 1) {
        if ((i * 3 + j * 7) % 11 == 0) {
            if (i != j) {
                adj[i][j] = 1;
            }
        }
    }
}
let start = Date.to_millis();
let visited = [];
for (let i = 0; i < n; i = i + 1) {
    visited.push(false);
}
let stack = [];
stack.push(0);
let count = 0;
while (true) {
    if (stack.length == 0) {
        break;
    }
    let node = stack.pop();
    if (!visited[node]) {
        visited[node] = true;
        count = count + 1;
        for (let neighbor = n - 1; neighbor >= 0; neighbor = neighbor - 1) {
            if (adj[node][neighbor] == 1) {
                if (!visited[neighbor]) {
                    stack.push(neighbor);
                }
            }
        }
    }
}
let end = Date.to_millis();
print("Visited: " + count);
print("Time: " + (end - start) + "ms");
```

<a id="11-duffs-device"></a>
## 11. Duff's Device-Style Copy (`duffs_device`)

**Area:** Loop unrolling

C's original Duff's device interleaves a switch statement with a loop. HudHudScript does not reproduce that syntax; instead, this program preserves the central optimization idea by writing eight copy assignments explicitly inside each iteration. It copies 100,000 array elements and repeats the function 100 times. The test highlights indexed reads and writes, array allocation, and how manual unrolling changes the ratio of useful work to loop-control overhead.

Source: `benchmarks/src/hudhud/duffs_device.hud`

```hudhud
fn duffs_device(count) {
    let a = [];
    let b = [];
    let i = 0;
    while (i < count) {
        a.push(0);
        b.push(1);
        i = i + 1;
    }
    
    let n = count / 8;
    let rem = count % 8;
    i = 0;
    
    while (rem > 0) {
        a[i] = b[i];
        i = i + 1;
        rem = rem - 1;
    }
    
    while (n > 0) {
        a[i] = b[i]; i = i + 1;
        a[i] = b[i]; i = i + 1;
        a[i] = b[i]; i = i + 1;
        a[i] = b[i]; i = i + 1;
        a[i] = b[i]; i = i + 1;
        a[i] = b[i]; i = i + 1;
        a[i] = b[i]; i = i + 1;
        a[i] = b[i]; i = i + 1;
        n = n - 1;
    }
    return a[count - 1];
}

let start = Date.to_millis();
let res = 0;
let k = 0;
while (k < 100) {
    res = duffs_device(100000);
    k = k + 1;
}
let end = Date.to_millis();

print("Result: " + res);
print("Time: " + (end - start) + "ms");
```

<a id="12-fact"></a>
## 12. Iterative Factorial (`fact`)

**Area:** BigInt

The iterative factorial benchmark multiplies every integer from 10,000 down to one, producing the exact value of `10000!`. The accumulator soon outgrows every fixed-width integer type and eventually contains tens of thousands of decimal digits. Later multiplications are consequently much more expensive than earlier ones. A fast overflow or an `Infinity` result is not equivalent work; this case is explicitly about exact arbitrary-precision multiplication and storage.

Source: `benchmarks/src/hudhud/fact.hud`

```hudhud
let result = 1;
let n = 10000;
let start = Date.to_millis();
while (n > 1) {
    result = result * n;
    n = n - 1;
}
let end = Date.to_millis();
print("Result: " + result);
print("Time: " + (end - start) + "ms");
```

<a id="13-factorial-recursive"></a>
## 13. Recursive Factorial (`factorial_recursive`)

**Area:** BigInt / recursion

This version computes `150!` with the textbook recursive definition. The input is modest enough to keep the call depth practical, yet the answer is far beyond 64-bit range. Each returning frame multiplies its local value into an already growing integer. The benchmark therefore joins two concerns that are often measured separately: recursive frame management and exact BigInt values moving back through the return chain.

Source: `benchmarks/src/hudhud/factorial_recursive.hud`

```hudhud
fn fact(n) {
    if (n <= 1) {
        return 1;
    }
    return n * fact(n - 1);
}
let start = Date.to_millis();
let result = fact(150);
let end = Date.to_millis();
print("fact(150) = " + result);
print("Time: " + (end - start) + "ms");
```

<a id="14-fannkuch-redux"></a>
## 14. Fannkuch Redux (`fannkuch_redux`)

**Area:** Permutations

Fannkuch Redux enumerates permutations and counts how many prefix reversals are needed to bring the first element back to zero. At `n = 9`, the program tracks both an alternating checksum and the maximum flip count. Small arrays are copied, swapped, and reversed again and again. Its compact implementation creates a large volume of conditional, data-dependent work, which is why Fannkuch has long been useful in cross-language runtime comparisons.


> **Note:** This is a simplified, stress-test variant of Fannkuch. It does not compute the full `n!` permutation checksum defined by the Computer Language Benchmarks Game, but rather serves to heavily stress the VM\'s array copying and loop condition handling.

Source: `benchmarks/src/hudhud/fannkuch_redux.hud`

```hudhud
fn fannkuch(n) {
    let p = []; let q = []; let s = [];
    let i = 0;
    while (i < n) {
        p.push(i);
        q.push(i);
        s.push(i);
        i = i + 1;
    }
    
    let sign = 1;
    let maxflips = 0;
    let sumflips = 0;
    
    while (true) {
        let q1 = p[0];
        if (q1 != 0) {
            let j = 1;
            while (j < n) {
                q[j] = p[j];
                j = j + 1;
            }
            let flips = 1;
            while (true) {
                let qq = q[q1];
                if (qq == 0) {
                    break;
                }
                q[q1] = q1;
                if (q1 >= 3) {
                    let a = 1;
                    let b = q1 - 1;
                    while (a < b) {
                        let temp = q[a];
                        q[a] = q[b];
                        q[b] = temp;
                        a = a + 1;
                        b = b - 1;
                    }
                }
                q1 = qq;
                flips = flips + 1;
            }
            if (flips > maxflips) {
                maxflips = flips;
            }
            sumflips = sumflips + sign * flips;
        }
        
        if (sign == 1) {
            let temp2 = p[1];
            p[1] = p[0];
            p[0] = temp2;
            sign = -1;
        } else {
            let temp3 = p[1];
            p[1] = p[2];
            p[2] = temp3;
            sign = 1;
            let k = 2;
            let broken = false;
            while (k < n) {
                s[k] = s[k] - 1;
                if (s[k] != 0) {
                    broken = true;
                    break;
                }
                s[k] = k;
                let t = p[0];
                let m = 0;
                while (m <= k) {
                    if (m < k) {
                        p[m] = p[m + 1];
                    } else {
                        p[m] = t;
                    }
                    m = m + 1;
                }
                k = k + 1;
            }
            if (!broken) {
                break;
            }
        }
    }
    return sumflips + "_" + maxflips;
}

let start = Date.to_millis();
let res = fannkuch(9);
let end = Date.to_millis();

print("Result: " + res);
print("Time: " + (end - start) + "ms");
```

<a id="15-fasta"></a>
## 15. FASTA Generation (`fasta`)

**Area:** Strings / random

The FASTA workload generates synthetic biological sequence data without involving file I/O. It repeats a fixed ALU fragment and chooses characters from a weighted IUB alphabet with a fixed-seed linear congruential generator. The program mixes string indexing and concatenation with floating-point probability thresholds, array lookup, modular random-number arithmetic, and chunk-oriented output logic. Using a fixed seed keeps the generated work reproducible.


> **Note:** This is a "FASTA-like" deterministic nucleotide workload. Instead of generating and outputting a standard sequence string, it focuses on the internal mechanics—probability loops, array indexing, and length accounting.

Source: `benchmarks/src/hudhud/fasta.hud`

```hudhud
let start = Date.to_millis();

let seed = 42;
fn rand(max_val) {
    seed = (seed * 3877 + 29573) % 139968;
    let seed_float = seed * 1.0;
    return max_val * seed_float / 139968.0;
}

let alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

let iub_c = ["a", "c", "g", "t", "B", "D", "H", "K", "M", "N", "R", "S", "V", "W", "Y"];
let iub_p = [0.27, 0.12, 0.12, 0.27, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02];

let cp = 0.0;
let i = 0;
while (i < iub_p.length) {
    cp = cp + iub_p[i];
    iub_p[i] = cp;
    i = i + 1;
}

let res = 0;
let n = 50000;

let alu_idx = 0;
let total = n * 2;
while (total > 0) {
    let chunk = 60;
    if (total < 60) { chunk = total; }
    res = res + chunk;
    total = total - chunk;
    alu_idx = (alu_idx + chunk) % alu.length;
}

total = n * 3;
while (total > 0) {
    let chunk = 60;
    if (total < 60) { chunk = total; }
    let c = 0;
    while (c < chunk) {
        let r = rand(1.0);
        let j = 0;
        while (j < iub_p.length) {
            if (r < iub_p[j]) {
                res = res + 1;
                break;
            }
            j = j + 1;
        }
        c = c + 1;
    }
    total = total - chunk;
}

let end = Date.to_millis();
print("Result: " + res);
print("Time: " + (end - start) + "ms");
```

<a id="16-fib"></a>
## 16. Recursive Fibonacci (`fib`)

**Area:** Recursion

This is the familiar direct definition of Fibonacci: values below two return immediately, and every other value becomes the sum of two recursive calls. Computing `fib(30)` this way is intentionally inefficient. The exponential call tree consists mostly of tiny frames that compare, call, add, and return. With no cache and almost no allocation, the result is a focused view of recursive dispatch overhead.

Source: `benchmarks/src/hudhud/fib.hud`

```hudhud
fn fib(n) {
    if (n < 2) { return n; }
    return fib(n - 1) + fib(n - 2);
}
let start = Date.to_millis();
let result = fib(30);
let end = Date.to_millis();
print("fib(30) = " + result);
print("Time: " + (end - start) + "ms");
```

<a id="17-fib-iterative"></a>
## 17. Iterative Fibonacci (`fib_iterative`)

**Area:** BigInt

An iterative two-variable loop calculates `fib(1000)`, and the benchmark repeats that calculation 10,000 times. Since `fib(1000)` has 209 decimal digits, every correct implementation must leave fixed-width arithmetic behind while preserving an exact answer. Unlike recursive Fibonacci, this version has simple, predictable control flow. Its time is dominated by repeated BigInt addition, assignment, and accumulation.

Source: `benchmarks/src/hudhud/fib_iterative.hud`

```hudhud
fn fib(n) {
    if (n <= 1) {
        return n;
    }
    let a = 0;
    let b = 1;
    for (let i = 2; i <= n; i = i + 1) {
        let temp = a + b;
        a = b;
        b = temp;
    }
    return b;
}
let start = Date.to_millis();
let sum = 0;
for (let i = 0; i < 10000; i = i + 1) {
    sum = sum + fib(1000);
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="18-fib-memo"></a>
## 18. Fibonacci Table Construction (`fib_memo`)

**Area:** BigInt / arrays

Each of 10,000 iterations begins with `[0, 1]`, builds a Fibonacci array through index 500, and adds the final entry to a running sum. The table is rebuilt on purpose instead of being retained between iterations. As a result, this benchmark measures growing exact integers and the machinery around them: indexed reads, array appends, fresh allocation, and the repeated construction of a memo-style table.

Source: `benchmarks/src/hudhud/fib_memo.hud`

```hudhud
let start = Date.to_millis();
let sum = 0;
let i = 0;
while (i < 10000) {
    let memo = [0, 1];
    let j = 2;
    while (j <= 500) {
        memo.push(memo[j - 1] + memo[j - 2]);
        j = j + 1;
    }
    sum = sum + memo[500];
    i = i + 1;
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="19-gcd"></a>
## 19. Euclidean Greatest Common Divisor (`gcd`)

**Area:** Integer arithmetic

The Euclidean algorithm repeatedly replaces a pair of integers with the second value and the remainder of their division. This program applies that process to 10,000 deterministic pairs derived from the loop index. Different pairs require different numbers of reductions, so the inner loop remains data-dependent. The main costs are integer modulo, local-variable swaps, comparisons, function calls, and branches.

Source: `benchmarks/src/hudhud/gcd.hud`

```hudhud
fn gcd(a, b) {
    while (b != 0) {
        let temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}
let start = Date.to_millis();
let result = 0;
for (let i = 1; i <= 10000; i = i + 1) {
    result = gcd(i * 12345, i * 6789 + 1);
}
let end = Date.to_millis();
print("Result: " + result);
print("Time: " + (end - start) + "ms");
```

<a id="20-geometric-series"></a>
## 20. Geometric Series (`geometric_series`)

**Area:** Floating point

Beginning with a term of one and a ratio of 0.999, the program sums one million terms of a geometric sequence. Every iteration adds the current term and multiplies it by the ratio to obtain the next one. The dependency chain prevents the loop from skipping ahead. This is a clean floating-point test involving one addition, one multiplication, counter management, and the normal rounding and underflow behavior of a decaying series.

Source: `benchmarks/src/hudhud/geometric_series.hud`

```hudhud
let r = 0.999;
let sum = 0.0;
let term = 1.0;
let i = 0;
let start = Date.to_millis();
while (i < 1000000) {
    sum = sum + term;
    term = term * r;
    i = i + 1;
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="21-hanoi"></a>
## 21. Tower of Hanoi (`hanoi`)

**Area:** Recursion

The program does not model pegs or disks. Instead, it recursively counts the moves required to solve a 20-disk Tower of Hanoi: solve the smaller tower, make one move, and solve the smaller tower again. That formulation creates a full binary call tree with more than one million leaf-level operations. It tests predictable recursion, base-case branches, integer return values, and additions without allowing object allocation to dominate.

Source: `benchmarks/src/hudhud/hanoi.hud`

```hudhud
fn hanoi(n) {
    if (n == 1) {
        return 1;
    }
    return hanoi(n - 1) + 1 + hanoi(n - 1);
}
let start = Date.to_millis();
let moves = hanoi(20);
let end = Date.to_millis();
print("Moves: " + moves);
print("Time: " + (end - start) + "ms");
```

<a id="22-heap-sort"></a>
## 22. Heap Sort (`heap_sort`)

**Area:** Sorting

One thousand integers start in descending order. The algorithm first turns them into a max heap, then repeatedly moves the root to the end and sifts a replacement downward. Parent and child positions are computed arithmetically, and each sift follows a data-dependent path through the array. Heap sort therefore stresses indexed access, comparisons, swaps, and nested loops with a markedly different locality pattern from merge or insertion sort.

Source: `benchmarks/src/hudhud/heap_sort.hud`

```hudhud
let arr = [];
for (let i = 1000; i > 0; i = i - 1) {
    arr.push(i);
}
let start = Date.to_millis();
let n = arr.length;
for (let j = n / 2 - 1; j >= 0; j = j - 1) {
    let idx = j;
    while (true) {
        let largest = idx;
        let left = 2 * idx + 1;
        let right = 2 * idx + 2;
        if (left < n) {
            if (arr[left] > arr[largest]) {
                largest = left;
            }
        }
        if (right < n) {
            if (arr[right] > arr[largest]) {
                largest = right;
            }
        }
        if (largest == idx) {
            break;
        }
        let temp = arr[idx];
        arr[idx] = arr[largest];
        arr[largest] = temp;
        idx = largest;
    }
}
for (let k = n - 1; k > 0; k = k - 1) {
    let temp = arr[0];
    arr[0] = arr[k];
    arr[k] = temp;
    let idx = 0;
    while (true) {
        let largest = idx;
        let left = 2 * idx + 1;
        let right = 2 * idx + 2;
        if (left < k) {
            if (arr[left] > arr[largest]) {
                largest = left;
            }
        }
        if (right < k) {
            if (arr[right] > arr[largest]) {
                largest = right;
            }
        }
        if (largest == idx) {
            break;
        }
        let temp2 = arr[idx];
        arr[idx] = arr[largest];
        arr[largest] = temp2;
        idx = largest;
    }
}
let end = Date.to_millis();
print("First: " + arr[0]);
print("Last: " + arr[n - 1]);
print("Time: " + (end - start) + "ms");
```

<a id="23-insertion-sort"></a>
## 23. Insertion Sort (`insertion_sort`)

**Area:** Sorting

Insertion sort grows a sorted prefix one item at a time. Because the 1,000-element input is reversed, every new key must travel all the way through the existing prefix, producing the algorithm's quadratic worst case. Most of the work consists of comparing values and shifting array elements one position to the right. This makes assignment cost, backward indexing, branch behavior, and nested-loop dispatch especially visible.

Source: `benchmarks/src/hudhud/insertion_sort.hud`

```hudhud
let n = 1000;
let arr = [];
for (let i = n; i > 0; i = i - 1) {
    arr.push(i);
}
let start = Date.to_millis();
for (let j = 1; j < n; j = j + 1) {
    let key = arr[j];
    let k = j - 1;
    while (true) {
        if (k < 0) {
            break;
        }
        if (arr[k] > key) {
            arr[k + 1] = arr[k];
            k = k - 1;
        } else {
            break;
        }
    }
    arr[k + 1] = key;
}
let end = Date.to_millis();
print("First: " + arr[0]);
print("Last: " + arr[n - 1]);
print("Time: " + (end - start) + "ms");
```

<a id="24-k-nucleotide"></a>
## 24. K-Nucleotide Frequencies (`k_nucleotide`)

**Area:** Strings / bioinformatics

A fixed-seed generator creates a 100,000-character DNA string drawn from A, C, G, and T. The program scans overlapping windows of lengths one, two, and three, converts each nucleotide to a base-four digit, and increments a corresponding frequency slot. This avoids hash-table differences while retaining the essence of k-mer counting. String construction, character indexing, classification branches, random arithmetic, and dense array updates all contribute.

Source: `benchmarks/src/hudhud/k_nucleotide.hud`

```hudhud
fn char_to_int(c) {
    if (c == "A") { return 0; }
    if (c == "C") { return 1; }
    if (c == "G") { return 2; }
    if (c == "T") { return 3; }
    return 0;
}

let start = Date.to_millis();

let chars = ["A", "C", "G", "T"];
let dna = "";
let seed = 42;
let idx_loop = 0;
while (idx_loop < 100000) {
    seed = (seed * 1103515245 + 12345) % 2147483648;
    let char_idx = (seed / 65536) % 4;
    dna = dna + chars[char_idx];
    idx_loop = idx_loop + 1;
}

let freq1 = [0, 0, 0, 0];
let i1 = 0;
while (i1 < 100000) {
    let c = char_to_int(dna[i1]);
    freq1[c] = freq1[c] + 1;
    i1 = i1 + 1;
}

let freq2 = [];
let f2i = 0;
while (f2i < 16) { freq2.push(0); f2i = f2i + 1; }
let i2 = 0;
while (i2 < 100000 - 1) {
    let c1 = char_to_int(dna[i2]);
    let c2 = char_to_int(dna[i2 + 1]);
    let code = c1 * 4 + c2;
    freq2[code] = freq2[code] + 1;
    i2 = i2 + 1;
}

let freq3 = [];
let f3i = 0;
while (f3i < 64) { freq3.push(0); f3i = f3i + 1; }
let i3 = 0;
while (i3 < 100000 - 2) {
    let c1 = char_to_int(dna[i3]);
    let c2 = char_to_int(dna[i3 + 1]);
    let c3 = char_to_int(dna[i3 + 2]);
    let code = c1 * 16 + c2 * 4 + c3;
    freq3[code] = freq3[code] + 1;
    i3 = i3 + 1;
}

let unique_count = 0;
let f1k = 0; while (f1k < 4) { if (freq1[f1k] > 0) { unique_count = unique_count + 1; } f1k = f1k + 1; }
let f2k = 0; while (f2k < 16) { if (freq2[f2k] > 0) { unique_count = unique_count + 1; } f2k = f2k + 1; }
let f3k = 0; while (f3k < 64) { if (freq3[f3k] > 0) { unique_count = unique_count + 1; } f3k = f3k + 1; }

let end = Date.to_millis();
print("Count: " + unique_count);
print("Time: " + (end - start) + "ms");
```

<a id="25-knapsack"></a>
## 25. 0/1 Knapsack (`knapsack`)

**Area:** Dynamic programming

Fifty deterministic items receive weights and values, and a dynamic-programming table finds the best value that fits within capacity 100. For every item and capacity, the program chooses between carrying forward the previous optimum and including the current item once. The recurrence fills a dense two-dimensional array, exercising nested allocation, repeated neighboring reads, conditional maximum selection, and writes across the table.

Source: `benchmarks/src/hudhud/knapsack.hud`

```hudhud
let weights = [];
let values = [];
for (let i = 0; i < 50; i = i + 1) {
    weights.push((i * 7 + 3) % 20 + 1);
    values.push((i * 13 + 5) % 50 + 10);
}
let capacity = 100;
let start = Date.to_millis();
let n = 50;
let dp = [];
for (let i = 0; i <= n; i = i + 1) {
    let row = [];
    for (let j = 0; j <= capacity; j = j + 1) {
        row.push(0);
    }
    dp.push(row);
}
for (let i = 1; i <= n; i = i + 1) {
    for (let w = 0; w <= capacity; w = w + 1) {
        if (weights[i - 1] <= w) {
            let incl = values[i - 1] + dp[i - 1][w - weights[i - 1]];
            if (incl > dp[i - 1][w]) {
                dp[i][w] = incl;
            } else {
                dp[i][w] = dp[i - 1][w];
            }
        } else {
            dp[i][w] = dp[i - 1][w];
        }
    }
}
let end = Date.to_millis();
print("Max: " + dp[n][capacity]);
print("Time: " + (end - start) + "ms");
```

<a id="26-lcs"></a>
## 26. Longest Common Subsequence (`lcs`)

**Area:** Dynamic programming

The longest-common-subsequence program compares two deterministic 100-character strings. A 101-by-101 table stores the best answer for every pair of prefixes: matching characters extend the diagonal result, while mismatches choose the better adjacent value. It is a compact version of the work found in sequence alignment. Character indexing, equality tests, two-dimensional table access, and branch-driven recurrence updates fill the timed region.

Source: `benchmarks/src/hudhud/lcs.hud`

```hudhud
let chars1 = [];
let chars2 = [];
for (let i = 0; i < 10; i = i + 1) {
    chars1.push("abcdefghij");
    chars2.push("acegikmoqs");
}
let s1 = chars1.join("");
let s2 = chars2.join("");
let start = Date.to_millis();
let m = 100;
let n = 100;
let dp = [];
for (let i = 0; i <= m; i = i + 1) {
    let row = [];
    for (let j = 0; j <= n; j = j + 1) {
        row.push(0);
    }
    dp.push(row);
}
for (let i = 1; i <= m; i = i + 1) {
    for (let j = 1; j <= n; j = j + 1) {
        if (s1[i - 1] == s2[j - 1]) {
            dp[i][j] = dp[i - 1][j - 1] + 1;
        } else {
            dp[i][j] = dp[i - 1][j];
            if (dp[i][j - 1] > dp[i][j]) {
                dp[i][j] = dp[i][j - 1];
            }
        }
    }
}
let end = Date.to_millis();
print("LCS: " + dp[m][n]);
print("Time: " + (end - start) + "ms");
```

<a id="27-mandelbrot"></a>
## 27. Mandelbrot Set (`mandelbrot`)

**Area:** Floating point

The program maps a 500-by-500 grid onto the complex plane. At each point it applies `z = z² + c` for as many as 50 iterations, stopping when the magnitude exceeds two. Some points escape quickly while others consume the full budget, so inner-loop lengths vary across the image. The workload is rich in floating-point multiplication and addition, coordinate conversion, nested loops, and data-dependent exits.


> **Note:** Although the variable may be named `sum_iters`, the algorithm actually accumulates the count of escaped points (escape flags), not the raw total of iterations.

Source: `benchmarks/src/hudhud/mandelbrot.hud`

```hudhud
fn mandelbrot(size) {
    let sum_iters = 0;
    let y = 0;
    while (y < size) {
        let x = 0;
        while (x < size) {
            let zr = 0.0;
            let zi = 0.0;
            let cr = (2.0 * x / size) - 1.5;
            let ci = (2.0 * y / size) - 1.0;
            let escape = 0;
            let i = 0;
            while (i < 50) {
                let tr = zr * zr - zi * zi + cr;
                let ti = 2.0 * zr * zi + ci;
                zr = tr;
                zi = ti;
                if (zr * zr + zi * zi > 4.0) {
                    escape = 1;
                    i = 50;
                } else {
                    i = i + 1;
                }
            }
            sum_iters = sum_iters + escape;
            x = x + 1;
        }
        y = y + 1;
    }
    return sum_iters;
}

let start = Date.to_millis();
let res = mandelbrot(500);
let end = Date.to_millis();

print("Sum: " + res);
print("Time: " + (end - start) + "ms");
```

<a id="28-matrix"></a>
## 28. Matrix Multiplication (`matrix`)

**Area:** Linear algebra

Two deterministic 150-by-150 matrices are multiplied with the direct three-loop algorithm. For every output coordinate, the innermost loop reads a row from the first matrix and a column from the second, then accumulates their products. No specialized matrix library is involved. This makes nested-array lookup, numeric multiplication and addition, loop dispatch at three levels, and storage locality central to the measurement.

Source: `benchmarks/src/hudhud/matrix.hud`

```hudhud
let size = 150;
let a = [];
let b = [];
let c = [];
for (let i = 0; i < size; i = i + 1) {
    let row_a = [];
    let row_b = [];
    let row_c = [];
    for (let j = 0; j < size; j = j + 1) {
        row_a.push(i + j);
        row_b.push(i - j);
        row_c.push(0);
    }
    a.push(row_a);
    b.push(row_b);
    c.push(row_c);
}
let start = Date.to_millis();
for (let i = 0; i < size; i = i + 1) {
    for (let j = 0; j < size; j = j + 1) {
        for (let k = 0; k < size; k = k + 1) {
            c[i][j] = c[i][j] + a[i][k] * b[k][j];
        }
    }
}
let end = Date.to_millis();
print("Result[0][0]: " + c[0][0]);
print("Result[149][149]: " + c[149][149]);
print("Time: " + (end - start) + "ms");
```

<a id="29-matrix-transpose"></a>
## 29. Matrix Transpose (`matrix_transpose`)

**Area:** Arrays

Every element of a 300-by-300 matrix is copied into the reversed coordinate of a second matrix: `t[j][i]` receives `m[i][j]`. The arithmetic is trivial, which is precisely the point. Runtime is governed by two-dimensional indexing, nested-loop overhead, reads in one orientation, and writes in the other. It is a useful memory-access counterpart to the much more arithmetic-heavy matrix multiplication case.

Source: `benchmarks/src/hudhud/matrix_transpose.hud`

```hudhud
let size = 300;
let m = [];
let t = [];
for (let i = 0; i < size; i = i + 1) {
    let row_m = [];
    let row_t = [];
    for (let j = 0; j < size; j = j + 1) {
        row_m.push(i + j);
        row_t.push(0);
    }
    m.push(row_m);
    t.push(row_t);
}
let start = Date.to_millis();
for (let i = 0; i < size; i = i + 1) {
    for (let j = 0; j < size; j = j + 1) {
        t[j][i] = m[i][j];
    }
}
let end = Date.to_millis();
print("T[0][0]: " + t[0][0]);
print("T[299][299]: " + t[299][299]);
print("Time: " + (end - start) + "ms");
```

<a id="30-mean-variance"></a>
## 30. Mean and Variance (`mean_variance`)

**Area:** Statistics

An array contains the integers from one through 1,000,000. The first timed pass calculates their arithmetic mean; the second calculates population variance from squared differences. Both passes are sequential, but the second introduces conversion to floating point, subtraction, multiplication, and a second accumulation. This benchmark reflects a common statistical pattern and exposes the runtime's treatment of large numeric arrays and rounding over long sums.

Source: `benchmarks/src/hudhud/mean_variance.hud`

```hudhud
let arr = [];
let i = 0;
while (i < 1000000) {
    arr.push(i + 1);
    i = i + 1;
}
let start = Date.to_millis();
let sum = 0.0;
i = 0;
while (i < 1000000) {
    sum = sum + arr[i];
    i = i + 1;
}
let mean = sum / 1000000.0;
let sq_diff = 0.0;
i = 0;
while (i < 1000000) {
    let diff = arr[i] * 1.0 - mean;
    sq_diff = sq_diff + diff * diff;
    i = i + 1;
}
let variance = sq_diff / 1000000.0;
let end = Date.to_millis();
print("Mean: " + mean);
print("Variance: " + variance);
print("Time: " + (end - start) + "ms");
```

<a id="31-merge"></a>
## 31. Merge Sort (`merge`)

**Area:** Sorting

This is an iterative, bottom-up merge sort over 1,000 reverse-ordered integers. Runs begin at width one and double until the whole array is sorted. Each merge copies the two source ranges into temporary arrays and writes the ordered result back. The workload has predictable `O(n log n)` comparisons while also measuring temporary allocation, sequential copying, array growth, and repeated writes to the original array.

Source: `benchmarks/src/hudhud/merge.hud`

```hudhud
let arr = [];
for (let i = 1000; i > 0; i = i - 1) {
    arr.push(i);
}
let start = Date.to_millis();
let n = 1000;
for (let width = 1; width < n; width = width * 2) {
    for (let left = 0; left < n; left = left + 2 * width) {
        let mid = left + width - 1;
        if (mid < n - 1) {
            let right = left + 2 * width - 1;
            if (right >= n) {
                right = n - 1;
            }
            let n1 = mid - left + 1;
            let n2 = right - mid;
            let L = [];
            let R = [];
            for (let k = 0; k < n1; k = k + 1) {
                L.push(arr[left + k]);
            }
            for (let k = 0; k < n2; k = k + 1) {
                R.push(arr[mid + 1 + k]);
            }
            let i1 = 0;
            let j1 = 0;
            let m = left;
            while (true) {
                if (!(i1 < n1 && j1 < n2)) {
                    break;
                }
                if (L[i1] <= R[j1]) {
                    arr[m] = L[i1];
                    i1 = i1 + 1;
                } else {
                    arr[m] = R[j1];
                    j1 = j1 + 1;
                }
                m = m + 1;
            }
            for (let ii = i1; ii < n1; ii = ii + 1) {
                arr[m] = L[ii];
                m = m + 1;
            }
            for (let jj = j1; jj < n2; jj = jj + 1) {
                arr[m] = R[jj];
                m = m + 1;
            }
        }
    }
}
let end = Date.to_millis();
print("First: " + arr[0]);
print("Last: " + arr[n - 1]);
print("Time: " + (end - start) + "ms");
```

<a id="32-modular-exp"></a>
## 32. Modular Exponentiation (`modular_exp`)

**Area:** Integer arithmetic

Binary exponentiation computes `3^1000 mod 1,000,000,007`, and the complete calculation is repeated 10,000 times. Squaring the base while halving the exponent reduces each power to a short sequence of multiplication, modulo, parity tests, and branches. The modulus keeps intermediate values bounded, so this test measures dense integer arithmetic rather than the ever-growing BigInt values seen in the unrestricted power benchmark.

Source: `benchmarks/src/hudhud/modular_exp.hud`

```hudhud
let start = Date.to_millis();
fn mod_exp(base, exp, mod) {
    let result = 1;
    let b = base % mod;
    let e = exp;
    while (e > 0) {
        if (e % 2 == 1) {
            result = (result * b) % mod;
        }
        b = (b * b) % mod;
        e = e / 2;
    }
    return result;
}

let sum = 0;
let i = 0;
while (i < 10000) {
    sum = sum + mod_exp(3, 1000, 1000000007);
    i = i + 1;
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="33-monte-carlo-pi"></a>
## 33. Monte Carlo Pi (`monte_carlo_pi`)

**Area:** Random / floating point

A fixed-seed Park-Miller generator produces 500,000 coordinate pairs in the unit square. The program counts how many satisfy `x² + y² <= 1`, then scales that fraction to estimate pi. Because the seed is fixed, every language sees the same reproducible stream. The timed section combines modular pseudo-random arithmetic, integer-to-float conversion, multiplication, addition, comparison, and conditional counting.

Source: `benchmarks/src/hudhud/monte_carlo_pi.hud`

```hudhud
let inside = 0;
let total = 500000;
let seed = 12345;
fn next_random() {
    seed = (seed * 16807) % 2147483647;
    return seed / 2147483647.0;
}
let start = Date.to_millis();
for (let i = 0; i < total; i = i + 1) {
    let x = next_random();
    let y = next_random();
    if (x * x + y * y <= 1.0) {
        inside = inside + 1;
    }
}
let end = Date.to_millis();
let pi = 4.0 * inside / total;
print("Pi: " + pi);
print("Time: " + (end - start) + "ms");
```

<a id="34-n-body"></a>
## 34. N-Body Simulation (`n_body`)

**Area:** Scientific computing

Five solar-system bodies are advanced through 10,000 time steps. Every step calculates pairwise gravitational interactions, updates velocities, and then advances positions; total system energy is measured before and after the simulation. The bodies are small arrays mutated in place. This classic scientific workload combines nested indexing with floating-point subtraction, multiplication, division, square roots, and the accumulation of numerical error across a long chain of dependent states.

Source: `benchmarks/src/hudhud/n_body.hud`

```hudhud


fn advance(bodies, dt) {
    let num_bodies = bodies.length;
    let i = 0;
    while (i < num_bodies) {
        let body_i = bodies[i];
        let j = i + 1;
        while (j < num_bodies) {
            let body_j = bodies[j];
            let dx = body_i[0] - body_j[0];
            let dy = body_i[1] - body_j[1];
            let dz = body_i[2] - body_j[2];
            
            let distance_sq = dx*dx + dy*dy + dz*dz;
            let distance = Math.sqrt(distance_sq);
            let mag = dt * (1.0 / (distance_sq * distance));
            
            body_i[3] = body_i[3] - dx * body_j[6] * mag;
            body_i[4] = body_i[4] - dy * body_j[6] * mag;
            body_i[5] = body_i[5] - dz * body_j[6] * mag;
            
            body_j[3] = body_j[3] + dx * body_i[6] * mag;
            body_j[4] = body_j[4] + dy * body_i[6] * mag;
            body_j[5] = body_j[5] + dz * body_i[6] * mag;
            
            j = j + 1;
        }
        i = i + 1;
    }
    
    let k = 0;
    while (k < num_bodies) {
        let body = bodies[k];
        body[0] = body[0] + dt * body[3];
        body[1] = body[1] + dt * body[4];
        body[2] = body[2] + dt * body[5];
        k = k + 1;
    }
}

fn energy(bodies) {
    let e = 0.0;
    let num_bodies = bodies.length;
    let i = 0;
    while (i < num_bodies) {
        let body_i = bodies[i];
        e = e + 0.5 * body_i[6] * (body_i[3]*body_i[3] + body_i[4]*body_i[4] + body_i[5]*body_i[5]);
        let j = i + 1;
        while (j < num_bodies) {
            let body_j = bodies[j];
            let dx = body_i[0] - body_j[0];
            let dy = body_i[1] - body_j[1];
            let dz = body_i[2] - body_j[2];
            let distance = Math.sqrt(dx*dx + dy*dy + dz*dz);
            e = e - (body_i[6] * body_j[6]) * (1.0 / distance);
            j = j + 1;
        }
        i = i + 1;
    }
    return e;
}

let PI = 3.141592653589793;
let SOLAR_MASS = 4.0 * PI * PI;
let DAYS_PER_YEAR = 365.24;

let bodies = [
    [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS],
    [4.84143144246472090, -1.16032004402742839, -0.103622044471123109,
     1.66007664274403694 * 0.001 * DAYS_PER_YEAR, 7.69901118419740425 * 0.001 * DAYS_PER_YEAR, -6.90460016972063023 * 0.00001 * DAYS_PER_YEAR,
     9.54791938424326609 * 0.0001 * SOLAR_MASS],
    [8.34336671824457987, 4.12479856412430479, -0.403523417114321381,
     -2.76742510726862411 * 0.001 * DAYS_PER_YEAR, 4.99852801234917238 * 0.001 * DAYS_PER_YEAR, 2.30417297573763929 * 0.00001 * DAYS_PER_YEAR,
     2.85885980666130812 * 0.0001 * SOLAR_MASS],
    [12.8943695621391310, -15.1111514016986312, -0.223307578892655734,
     2.96460137564761618 * 0.001 * DAYS_PER_YEAR, 2.37847173959480950 * 0.001 * DAYS_PER_YEAR, -2.96589568540237556 * 0.00001 * DAYS_PER_YEAR,
     4.36624404335156298 * 0.00001 * SOLAR_MASS],
    [15.3796971148509165, -25.9193146099879641, 0.179258772950371181,
     2.68067772490389322 * 0.001 * DAYS_PER_YEAR, 1.62824170038242295 * 0.001 * DAYS_PER_YEAR, -9.51592254519715870 * 0.00001 * DAYS_PER_YEAR,
     5.15138902046611451 * 0.00001 * SOLAR_MASS]
];

let px = 0.0; let py = 0.0; let pz = 0.0;
let b = 0;
while (b < bodies.length) {
    let body = bodies[b];
    px = px + body[3] * body[6];
    py = py + body[4] * body[6];
    pz = pz + body[5] * body[6];
    b = b + 1;
}
bodies[0][3] = -px * (1.0 / SOLAR_MASS);
bodies[0][4] = -py * (1.0 / SOLAR_MASS);
bodies[0][5] = -pz * (1.0 / SOLAR_MASS);

let start = Date.to_millis();

let e1 = energy(bodies);
let step = 0;
while (step < 10000) {
    advance(bodies, 0.01);
    step = step + 1;
}
let e2 = energy(bodies);

let end = Date.to_millis();

print("Result: " + e1 + "_" + e2);
print("Time: " + (end - start) + "ms");
```

<a id="35-n-queens"></a>
## 35. Eight Queens (`n_queens`)

**Area:** Backtracking

The eight-queens problem asks for every way to place eight queens so that no pair shares a column or diagonal. This implementation explores the search space iteratively, storing the chosen column for each row and moving backward whenever no safe column remains. The benchmark is dominated by constraint checks, small-array mutation, branches, and repeated changes of control-flow direction as the search advances and backtracks.

Source: `benchmarks/src/hudhud/n_queens.hud`

```hudhud
let board = [];
let start = Date.to_millis();
let count = 0;
let row = 0;
let col = 0;
while (row >= 0) {
    if (row == 8) {
        count = count + 1;
        row = row - 1;
        if (row >= 0) { col = board[row] + 1; }
    } else {
        let found = false;
        while (col < 8) {
            let safe = true;
            for (let i = 0; i < row; i = i + 1) {
                if (board[i] == col || board[i] - col == i - row || board[i] - col == row - i) {
                    safe = false;
                    break;
                }
            }
            if (safe) {
                board[row] = col;
                row = row + 1;
                col = 0;
                found = true;
                break;
            }
            col = col + 1;
        }
        if (!found) { row = row - 1; if (row >= 0) { col = board[row] + 1; } }
    }
}
let end = Date.to_millis();
print("Solutions: " + count);
print("Time: " + (end - start) + "ms");
```

<a id="36-newton-sqrt"></a>
## 36. Newton Square Roots (`newton_sqrt`)

**Area:** Floating point

For each integer from one through 10,000, the program runs exactly 20 Newton-Raphson refinements to approximate its square root. The approximations are accumulated into one final value. A fixed iteration count keeps the amount of work stable even though convergence speed varies. Floating-point division is the most expensive primitive in the recurrence, accompanied by addition, scaling, assignments, and predictable nested loops.

Source: `benchmarks/src/hudhud/newton_sqrt.hud`

```hudhud
let start = Date.to_millis();
let sum = 0.0;
let n = 1;
while (n <= 10000) {
    let x = n / 2.0;
    let i = 0;
    while (i < 20) {
        x = (x + n / x) / 2.0;
        i = i + 1;
    }
    sum = sum + x;
    n = n + 1;
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="37-palindrome"></a>
## 37. Palindrome Check (`palindrome`)

**Area:** Strings

The input is a 50,000-character string containing only `a`, and the program tests it for palindromic symmetry 1,000 times. Two indices move inward while mirrored characters are compared. Since no mismatch exists, every call traverses the full string instead of returning early. That gives a stable measurement of string length access, character indexing, equality checks, function calls, and tight two-pointer loops.

Source: `benchmarks/src/hudhud/palindrome.hud`

```hudhud
let s = "";
for (let i = 0; i < 50000; i = i + 1) {
    s = s + "a";
}
fn is_pal(str) {
    let left = 0;
    let right = str.length - 1;
    while (left < right) {
        if (str[left] != str[right]) { return false; }
        left = left + 1;
        right = right - 1;
    }
    return true;
}
let start = Date.to_millis();
let ok = true;
for (let i = 0; i < 1000; i = i + 1) {
    ok = is_pal(s);
}
let end = Date.to_millis();
if (ok) {
    print("Palindrome: true");
} else {
    print("Palindrome: false");
}
print("Time: " + (end - start) + "ms");
```

<a id="38-polynomial-eval"></a>
## 38. Polynomial Evaluation (`polynomial_eval`)

**Area:** Floating point

A degree-1,000 polynomial with deterministic coefficients is evaluated at 1.5 by Horner's method, and the evaluation is repeated 100,000 times. Horner's method turns the polynomial into a reverse traversal in which every multiply-add depends on the previous result. The benchmark measures floating-point arithmetic, indexed coefficient reads, function calls, and a dependency chain that prevents independent iterations from being freely reordered.

Source: `benchmarks/src/hudhud/polynomial_eval.hud`

```hudhud
let coeffs = [];
let i = 0;
while (i <= 1000) {
    coeffs.push(i + 1);
    i = i + 1;
}
fn horner(coeffs, x) {
    let result = coeffs[1000];
    let i = 999;
    while (i >= 0) {
        result = result * x + coeffs[i];
        i = i - 1;
    }
    return result;
}
let start = Date.to_millis();
let sum = 0.0;
let k = 0;
while (k < 100000) {
    sum = sum + horner(coeffs, 1.5);
    k = k + 1;
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="39-power"></a>
## 39. Repeated Power (`power`)

**Area:** BigInt

A straightforward multiplication loop calculates `2^1000`; the program repeats that work 10,000 times and adds each 301-digit result to a total. There is no modulus to keep values small, and floating-point infinity is not an acceptable substitute. This test is about exact BigInt multiplication and addition under predictable control flow, providing a useful counterpart to bounded modular exponentiation.

Source: `benchmarks/src/hudhud/power.hud`

```hudhud
fn power(base, exp) {
    let result = 1;
    for (let i = 0; i < exp; i = i + 1) {
        result = result * base;
    }
    return result;
}
let sum = 0;
let start = Date.to_millis();
for (let i = 0; i < 10000; i = i + 1) {
    sum = sum + power(2, 1000);
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="40-prime-count"></a>
## 40. Prime Count by Trial Division (`prime_count`)

**Area:** Number theory

Every integer through 100,000 is tested for primality. After special-casing two and rejecting other even numbers, the function tries odd divisors until the divisor squared exceeds the candidate. Composite values often return early, whereas primes require the longest scan. The changing trip counts put integer modulo, multiplication, comparisons, function calls, and branch-heavy early returns at the center of the benchmark.

Source: `benchmarks/src/hudhud/prime_count.hud`

```hudhud
fn is_prime(n) {
    if (n < 2) { return false; }
    if (n == 2) { return true; }
    if (n % 2 == 0) { return false; }
    let i = 3;
    while (i * i <= n) {
        if (n % i == 0) { return false; }
        i = i + 2;
    }
    return true;
}
let count = 0;
let n = 2;
let start = Date.to_millis();
while (n <= 100000) {
    if (is_prime(n)) { count = count + 1; }
    n = n + 1;
}
let end = Date.to_millis();
print("Primes: " + count);
print("Time: " + (end - start) + "ms");
```

<a id="41-quick"></a>
## 41. Iterative Quick Sort (`quick`)

**Area:** Sorting

One thousand descending integers are sorted with a Lomuto-style partition step. Pending low and high bounds are kept in an explicit array stack, so recursive call cost is replaced by push and pop operations. The chosen pivot and reversed input make partition balance consequential. Indexed comparisons, swaps, stack management, and data-dependent subrange sizes determine the resulting runtime behavior.


> **Note:** The input is deliberately ordered in reverse, and the partition uses the last element as a pivot. This intentionally forces the algorithm into its worst-case scenario ($O(N^2)$) with highly unbalanced partitioning, strictly to maximize VM stress.

Source: `benchmarks/src/hudhud/quick.hud`

```hudhud
let n = 1000;
let arr = [];
let i = n;
while (i > 0) {
    arr.push(i);
    i = i - 1;
}
let start = Date.to_millis();
let stack = [];
stack.push(0);
stack.push(n - 1);
while (true) {
    if (stack.length == 0) {
        break;
    }
    let high = stack.pop();
    let low = stack.pop();
    if (low < high) {
        let pivot = arr[high];
        let pi = low - 1;
        for (let j = low; j < high; j = j + 1) {
            if (arr[j] <= pivot) {
                pi = pi + 1;
                let temp = arr[pi];
                arr[pi] = arr[j];
                arr[j] = temp;
            }
        }
        pi = pi + 1;
        let temp = arr[pi];
        arr[pi] = arr[high];
        arr[high] = temp;
        if (pi - 1 > low) {
            stack.push(low);
            stack.push(pi - 1);
        }
        if (pi + 1 < high) {
            stack.push(pi + 1);
            stack.push(high);
        }
    }
}
let end = Date.to_millis();
print("First: " + arr[0]);
print("Last: " + arr[n - 1]);
print("Time: " + (end - start) + "ms");
```

<a id="42-revcomp"></a>
## 42. Reverse Complement (`revcomp`)

**Area:** Strings / bioinformatics

A deterministic generator first creates a 500,000-character DNA sequence. The reverse-complement function scans from the final character to the first, maps nucleotide and ambiguity codes to their complements, and counts the resulting A characters; this scan runs ten times. A long chain of character comparisons handles the mapping. The benchmark therefore emphasizes reverse indexing, branch-heavy classification, repeated traversal, and large in-memory sequence handling.


> **Note:** The sequence generation process happens *inside* the benchmark timer. Thus, the workload measures both the generation phase and the ten reverse scans.

Source: `benchmarks/src/hudhud/revcomp.hud`

```hudhud
fn reverse_complement(seq) {
    let count_A = 0;
    let n = seq.length;
    let i = n - 1;
    while (i >= 0) {
        let c = seq[i];
        let rep = c;
        if (c == "A") { rep = "T"; }
        else if (c == "C") { rep = "G"; }
        else if (c == "G") { rep = "C"; }
        else if (c == "T") { rep = "A"; }
        else if (c == "U") { rep = "A"; }
        else if (c == "M") { rep = "K"; }
        else if (c == "R") { rep = "Y"; }
        else if (c == "W") { rep = "W"; }
        else if (c == "S") { rep = "S"; }
        else if (c == "Y") { rep = "R"; }
        else if (c == "K") { rep = "M"; }
        else if (c == "V") { rep = "B"; }
        else if (c == "H") { rep = "D"; }
        else if (c == "D") { rep = "H"; }
        else if (c == "B") { rep = "V"; }
        else if (c == "N") { rep = "N"; }
        else if (c == "a") { rep = "T"; }
        else if (c == "c") { rep = "G"; }
        else if (c == "g") { rep = "C"; }
        else if (c == "t") { rep = "A"; }
        else if (c == "u") { rep = "A"; }
        else if (c == "m") { rep = "K"; }
        else if (c == "r") { rep = "Y"; }
        else if (c == "w") { rep = "W"; }
        else if (c == "s") { rep = "S"; }
        else if (c == "y") { rep = "R"; }
        else if (c == "k") { rep = "M"; }
        else if (c == "v") { rep = "B"; }
        else if (c == "h") { rep = "D"; }
        else if (c == "d") { rep = "H"; }
        else if (c == "b") { rep = "V"; }
        else if (c == "n") { rep = "N"; }
        
        if (rep == "A") {
            count_A = count_A + 1;
        }
        i = i - 1;
    }
    return count_A;
}

let start = Date.to_millis();

let seq = [];
let seed = 42;
let chars = ["A", "C", "G", "T"];
let i = 0;
while (i < 500000) {
    seed = (seed * 1103515245 + 12345) % 2147483648;
    let idx = (seed / 65536) % 4;
    seq.push(chars[idx]);
    i = i + 1;
}

let res = 0;
let k = 0;
while (k < 10) {
    res = reverse_complement(seq);
    k = k + 1;
}

let end = Date.to_millis();

print("Result: " + res);
print("Time: " + (end - start) + "ms");
```

<a id="43-sieve"></a>
## 43. Sieve of Eratosthenes (`sieve`)

**Area:** Number theory

The sieve begins with a boolean array representing the integers through 10,000. For each value still marked prime, it clears multiples starting at `p²`; a final pass counts the surviving entries. The algorithm shares elimination work across candidates rather than testing each number independently. Array allocation and mutation, arithmetic index progression, nested loops, and predictable prime checks make up the workload.


> **Note:** The initial array allocation setup occurs *outside* the benchmark timer. The measured workload consists purely of the marking and counting loops.

Source: `benchmarks/src/hudhud/sieve.hud`

```hudhud
let limit = 10000;
let sieve = [];
for (let i = 0; i <= limit; i = i + 1) {
    sieve.push(true);
}
sieve[0] = false;
sieve[1] = false;
let start = Date.to_millis();
for (let p = 2; p * p <= limit; p = p + 1) {
    if (sieve[p]) {
        for (let multiple = p * p; multiple <= limit; multiple = multiple + p) {
            sieve[multiple] = false;
        }
    }
}
let count = 0;
for (let i = 2; i <= limit; i = i + 1) {
    if (sieve[i]) { count = count + 1; }
}
let end = Date.to_millis();
print("Primes up to 10000: " + count);
print("Time: " + (end - start) + "ms");
```

<a id="44-spectral-norm"></a>
## 44. Spectral Norm (`spectral_norm`)

**Area:** Linear algebra

This benchmark estimates the spectral norm of an implicit matrix at size 150. Matrix entries are computed from their indices rather than stored, and repeated multiplication by `A` and its transpose performs power iteration. The final estimate comes from two vector dot products and a square root. The program combines nested loops, function calls, vector mutation, floating-point division and accumulation, and recomputation of matrix elements.

Source: `benchmarks/src/hudhud/spectral_norm.hud`

```hudhud
fn eval_A(i, j) {
    let ii = i * 1.0;
    let jj = j * 1.0;
    return 1.0 / (((ii + jj) * (ii + jj + 1.0) / 2.0) + ii + 1.0);
}

fn eval_A_times_u(u, v, n) {
    let i = 0;
    while (i < n) {
        v[i] = 0.0;
        let j = 0;
        while (j < n) {
            v[i] = v[i] + eval_A(i, j) * u[j];
            j = j + 1;
        }
        i = i + 1;
    }
}

fn eval_At_times_u(u, v, n) {
    let i = 0;
    while (i < n) {
        v[i] = 0.0;
        let j = 0;
        while (j < n) {
            v[i] = v[i] + eval_A(j, i) * u[j];
            j = j + 1;
        }
        i = i + 1;
    }
}

fn eval_AtA_times_u(u, v, w, n) {
    eval_A_times_u(u, w, n);
    eval_At_times_u(w, v, n);
}



let start = Date.to_millis();
let n = 150;
let u = [];
let v = [];
let w = [];
let idx = 0;
while (idx < n) {
    u.push(1.0);
    v.push(0.0);
    w.push(0.0);
    idx = idx + 1;
}

let iter = 0;
while (iter < 10) {
    eval_AtA_times_u(u, v, w, n);
    eval_AtA_times_u(v, u, w, n);
    iter = iter + 1;
}

let vBv = 0.0;
let vv = 0.0;
let i = 0;
while (i < n) {
    vBv = vBv + u[i] * v[i];
    vv = vv + v[i] * v[i];
    i = i + 1;
}

let res = Math.sqrt(vBv * (1.0 / vv));
let end = Date.to_millis();

print("Result: " + res);
print("Time: " + (end - start) + "ms");
```

<a id="45-strcat"></a>
## 45. String Concatenation (`strcat`)

**Area:** Strings

Starting from an empty value, the program appends one `x` at a time until the string reaches 50,000 characters. Nothing else obscures the operation being measured. A runtime that copies the whole string after every append can turn this into quadratic work, while ropes, builders, or other representations behave very differently. The result is a direct probe of string allocation and concatenation strategy.

Source: `benchmarks/src/hudhud/strcat.hud`

```hudhud
let s = "";
let start = Date.to_millis();
for (let i = 0; i < 50000; i = i + 1) {
    s = s + "x";
}
let end = Date.to_millis();
print("Length: " + len(s));
print("Time: " + (end - start) + "ms");
```

<a id="46-strrev"></a>
## 46. String Reverse (`strrev`)

**Area:** Strings

The program prepares a 50,000-character string, walks it backward, appends each character to an array, and joins that array into the reversed result. Using a character buffer avoids repeated front concatenation, which would make string copying the dominant issue. The timed work instead reflects reverse character indexing, array growth, storage of many small values, and the final join operation.

Source: `benchmarks/src/hudhud/strrev.hud`

```hudhud
let chars = [];
for (let i = 0; i < 50000; i = i + 1) {
    chars.push("a");
}
let s = chars.join("");
let start = Date.to_millis();

let rev_chars = [];
for (let j = s.length - 1; j >= 0; j = j - 1) {
    rev_chars.push(s[j]);
}
let rev = rev_chars.join("");

let end = Date.to_millis();
print("Len: " + rev.length);
print("Time: " + (end - start) + "ms");
```

<a id="47-substring-search"></a>
## 47. Naive Substring Search (`substring_search`)

**Area:** Strings

A 10,000-character text is assembled from repeated `abcdefghij` blocks. The program slides the four-character pattern `defg` across every valid starting position and compares characters directly until a mismatch occurs or the full pattern matches. The periodic text supplies regular successes among many failures. String indexing, equality checks, early exits, and repeated short inner loops drive the measurement.

Source: `benchmarks/src/hudhud/substring_search.hud`

```hudhud
let text = "";
for (let i = 0; i < 1000; i = i + 1) {
    text = text + "abcdefghij";
}
let pattern = "defg";
let text_len = text.length;
let pat_len = pattern.length;
let count = 0;
let start = Date.to_millis();
for (let t = 0; t <= text_len - pat_len; t = t + 1) {
    let matched = true;
    for (let p = 0; p < pat_len; p = p + 1) {
        if (text[t + p] != pattern[p]) {
            matched = false;
            p = pat_len;
        }
    }
    if (matched) {
        count = count + 1;
    }
}
let end = Date.to_millis();
print("Count: " + count);
print("Time: " + (end - start) + "ms");
```

<a id="48-sum-of-squares"></a>
## 48. Sum of Squares (`sum_of_squares`)

**Area:** Wide/exact integer

The loop calculates `1² + 2² + ... + 1,000,000²` directly rather than replacing the work with a closed-form formula. The final value is larger than JavaScript's `Number.MAX_SAFE_INTEGER` and the exact-integer range of an IEEE-754 double, although it still fits in a signed 64-bit integer. This distinction matters when comparing numeric models. The benchmark performs one million integer multiplications, additions, and counter updates while requiring an exact result.

Source: `benchmarks/src/hudhud/sum_of_squares.hud`

```hudhud
let sum = 0;
let start = Date.to_millis();
for (let i = 1; i <= 1000000; i = i + 1) {
    sum = sum + i * i;
}
let end = Date.to_millis();
print("Sum: " + sum);
print("Time: " + (end - start) + "ms");
```

<a id="49-tak"></a>
## 49. Takeuchi Function (`tak`)

**Area:** Recursion

The Takeuchi function recursively evaluates three calls and passes their results into a fourth until its ordering condition becomes false. This program runs `tak(18, 12, 6)` ten times. Tak does very little useful arithmetic per frame, but creates an enormous amount of nested argument evaluation and return traffic. It is a demanding test of recursive frame creation, comparisons, call ordering, and value propagation.

Source: `benchmarks/src/hudhud/tak.hud`

```hudhud
fn tak(x, y, z) {
    if (y < x) {
        return tak(
            tak(x - 1, y, z),
            tak(y - 1, z, x),
            tak(z - 1, x, y)
        );
    }
    return z;
}

let start = Date.to_millis();
let res = 0;
let i = 0;
while (i < 10) {
    res = tak(18, 12, 6);
    i = i + 1;
}
let end = Date.to_millis();

print("Result: " + res);
print("Time: " + (end - start) + "ms");
```

<a id="50-vector-dot"></a>
## 50. Vector Dot Product (`vector_dot`)

**Area:** Wide/exact integer

Two deterministic vectors, each containing 500,000 elements, are traversed together. Every pair contributes one product to a scalar accumulator. This is among the simplest useful dense-numeric kernels, which makes its cost easy to interpret: two indexed reads, one multiplication, one addition, and loop control for every element. The exact result exceeds the safe-integer range of an IEEE-754 double but still fits in a signed 64-bit integer, so this is a wide/exact-integer case rather than a true arbitrary-precision BigInt workload.

Source: `benchmarks/src/hudhud/vector_dot.hud`

```hudhud
let a = [];
let b = [];
for (let i = 0; i < 500000; i = i + 1) {
    a.push(i + 1);
    b.push(i + 2);
}
let sum = 0;
let start = Date.to_millis();
for (let i = 0; i < 500000; i = i + 1) {
    sum = sum + a[i] * b[i];
}
let end = Date.to_millis();
print("Dot: " + sum);
print("Time: " + (end - start) + "ms");
```

## Reading the results as a profile

The suite does not collapse honestly into one universal ranking. A runtime can lead the numeric loops and trail the recursive programs. Efficient tree allocation says little about immutable string concatenation, and a quick overflow says nothing useful about exact BigInt performance.

The related benchmarks are particularly revealing. BFS and DFS traverse comparable graph data with different frontier structures. Fibonacci appears as direct recursion, an iterative BigInt loop, and repeated table construction. Prime counting uses both trial division and a sieve, while the sorting group covers adjacent swaps, backward shifts, heaps, merging, and partitioning. Those contrasts help identify the mechanism behind a timing difference instead of treating every result as an unexplained score.

Publishing the programs is therefore part of publishing the results. Readers can inspect the workload, check its correctness requirements, reproduce it, and decide whether it resembles the work that matters to them.
