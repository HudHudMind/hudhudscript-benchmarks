# HudHudScript Benchmarks (v0.8.219)

This repository contains the official benchmark suite for **HudHudScript v0.8.0**, comparing its execution performance against several popular programming languages including Python, Lua, Node.js, Ruby, PHP, and Perl.

The suite runs a variety of algorithms (sorting, mathematical functions, string manipulation, and classical benchmark problems) across all languages, tracking and storing the average execution times.

## How to Run

1. Ensure that you have Python 3 installed, along with any other language runtimes you wish to benchmark (e.g., `lua`, `node`, `ruby`, `php`, `perl`, `tclsh`).
2. Run the main benchmarking script:
   ```bash
   python3 run_benchmarks.py
   ```

### Advanced Benchmarking Options
The `run_benchmarks.py` script provides several powerful command-line arguments to customize your benchmark runs:

* **Specify run count:** `--runs <N>`
  Changes how many times each benchmark runs (default is 3).
  *Example:* `python3 run_benchmarks.py --runs 5`
* **Filter benchmarks:** `--only <benchmark1,benchmark2>`
  Runs only specific algorithms.
  *Example:* `python3 run_benchmarks.py --only fib,fact`
* **Filter languages:** `--languages <lang1,lang2>`
  Runs the benchmarks using only the specified languages.
  *Example:* `python3 run_benchmarks.py --languages python,lua,hudhud`
* **Skip compilation:** `--no-build`
  Skips rebuilding the HudHud binary before running (useful if you know it's already compiled).
* **Skip HudHud:** `--skip-hudhud`
  Runs benchmarks for all other languages except HudHudScript.
* **Dry Run:** `--dry-run`
  Prints what *would* be executed without actually running the benchmarks.
* **Profiling:**
  - `--profile`: Automatically generates callgrind and flamegraph profiles after the benchmarks complete.
  - `--profile-only-slow`: Only generates profiles for benchmarks where HudHud is significantly slower (>6x) than Python.

### Verifying Correctness
To ensure that all benchmarks across all languages are calculating the correct mathematical results and matching the "golden values" (expected outputs), you can run the correctness verifier:
```bash
python3 check_correctness.py
```

**Correctness Checker Options:**
* **`-v` or `--verbose`**: Shows detailed information about output mismatches and errors.
* **`--strict`**: Forces the script to exit with an error code (`1`) if any mismatch or missing result is detected. Great for CI/CD pipelines.
* **`--allow-incomplete`**: Evaluates correctness but does not fail if some language results are missing or outdated.
* **`--only <benchmark>`**: Verifies only the specified benchmark(s).
* **`--json`**: Outputs the verification report in JSON format instead of a terminal table.

### HudHudScript Auto-Detection
The script is designed to seamlessly locate the `hudhud` executable for benchmarking. It will search in the following order:

1. **Adjacent Directories**: If there is a `hudhud-script` or `hudhudscript` folder located in the parent directory (relative to this benchmark repository), the script will automatically discover and use the compiled binary (`target/release/hudhud` or `target/release-prof/hudhud`). It also supports `.exe` files for Windows users natively.
2. **System PATH**: If not found in the adjacent folders, it will fall back to searching your system's `PATH` (e.g., `/usr/bin/hudhud` or `/usr/local/bin/hudhud`).

## Debian Server Environment Benchmarks

These benchmarks were executed on a Debian Server machine to evaluate execution speed, correctness, and cross-platform performance.

**Hardware & OS:**
* **OS:** Debian GNU/Linux 12 (bookworm) x86_64 (Linux 6.1.0)
* **CPU:** Intel(R) Xeon(R) Silver 4114 CPU @ 2.20GHz (40 Cores / 2 Sockets)
* **RAM:** 32 GB (31 GiB)

**Programming Language Versions:**
* **HudHudScript:** v0.8.219
* **Python:** 3.11.2
* **Lua:** 5.4.4
* **Node.js:** v22.22.2
* **Ruby:** 3.1.2
* **PHP:** 8.2.30
* **Perl:** 5.36.0
* **Raku:** 2022.12
* **Tcl:** 8.6.13

Below is a summary of the benchmark results extracted on the Debian Server environment. **All times are in milliseconds (ms), and lower is better.**

| Benchmark | hudhud | python | lua | ruby | nodejs | php | perl | raku | tcl |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Ackermann Function | 46ms | 64ms | 20ms | 94ms | 63ms | 41ms | 65ms | 361ms | 79ms |
| AVL Insert | 2407ms | 1132ms | 603ms | 1061ms | 179ms | 700ms | 2780ms | 8266ms | 6954ms |
| Array Summation | 19ms | 35ms | 9ms | 88ms | 67ms | 36ms | 26ms | 336ms | 46ms |
| BFS Graph | 20ms | 34ms | 10ms | 89ms | 64ms | 38ms | 24ms | 404ms | 39ms |
| Binary Search | 57ms | 81ms | 39ms | 108ms | 78ms | 47ms | 73ms | 519ms | 311ms |
| Bubble Sort | 51ms | 82ms | 25ms | 113ms | 69ms | 45ms | 62ms | 713ms | 315ms |
| Collatz Conjecture | 81ms | 182ms | 59ms | 142ms | 71ms | 75ms | 138ms | 643ms | 172ms |
| Count Set Bits | 128ms | 275ms | 141ms | 177ms | 74ms | 120ms | 246ms | 915ms | 885ms |
| Cumulative Sum | 40ms | 64ms | 24ms | 101ms | 76ms | 42ms | 55ms | 555ms | 196ms |
| DFS Graph | 20ms | 36ms | 10ms | 90ms | 61ms | 37ms | 26ms | 407ms | 39ms |
| Factorial Iterative | 52ms | 72ms | 1150ms | 142ms | 96ms | 1375ms | 5138ms | 1021ms | 2251ms |
| Factorial Recursive | 15ms | 30ms | 8ms | 87ms | 45ms | 38ms | 23ms | 299ms | 14ms |
| Fibonacci Recursive | 317ms | 188ms | 125ms | 191ms | 82ms | 96ms | 539ms | 1235ms | 810ms |
| Fibonacci Iterative | 1015ms | 649ms | 14487ms | 2421ms | 499ms | 8168ms | 42136ms | 4776ms | 4172ms |
| Fibonacci Memoization | 2524ms | 1940ms | 5845ms | 1859ms | 364ms | 2770ms | 15363ms | 21671ms | 7348ms |
| Euclidean GCD | 33ms | 43ms | 19ms | 96ms | 67ms | 41ms | 49ms | 716ms | 54ms |
| Geometric Series | 85ms | 192ms | 48ms | 238ms | 80ms | 69ms | 102ms | 566ms | 1248ms |
| Tower of Hanoi | 153ms | 99ms | 59ms | 130ms | 69ms | 62ms | 236ms | 523ms | 352ms |
| Heap Sort | 20ms | 35ms | 11ms | 89ms | 71ms | 39ms | 30ms | 463ms | 35ms |
| Insertion Sort | 92ms | 124ms | 31ms | 118ms | 70ms | 51ms | 83ms | 506ms | 449ms |
| KMP Search | 2063ms | 2450ms | 2188ms | 3911ms | 378ms | 618ms | 2914ms | 11580ms | 13785ms |
| 0/1 Knapsack | 18ms | 34ms | 9ms | 90ms | 63ms | 37ms | 26ms | 426ms | 39ms |
| LCS | 24ms | 40ms | 15ms | 90ms | 76ms | 37ms | 30ms | 470ms | 51ms |
| Matrix Multiply | 435ms | 944ms | 192ms | 723ms | 119ms | 201ms | 503ms | 3947ms | 6022ms |
| Matrix Transpose | 40ms | 58ms | 33ms | 117ms | 77ms | 49ms | 59ms | 592ms | 206ms |
| Mean and Variance | 266ms | 374ms | 56ms | 291ms | 112ms | 92ms | 408ms | 2548ms | 3738ms |
| Merge Sort | 25ms | 39ms | 11ms | 89ms | 60ms | 37ms | 29ms | 479ms | 44ms |
| Modular Exponentiation | 39ms | 54ms | 30ms | 100ms | 79ms | 44ms | 49ms | 559ms | 64ms |
| Monte Carlo Pi | 245ms | 390ms | 93ms | 264ms | 98ms | 111ms | 262ms | 2118ms | 1202ms |
| Number Parse | 601ms | 1177ms | 658ms | 886ms | 223ms | 408ms | 930ms | 5581ms | 3082ms |
| N-Queens | 36ms | 54ms | 17ms | 94ms | 66ms | 38ms | 40ms | 434ms | 112ms |
| Newton-Raphson Sqrt | 34ms | 50ms | 17ms | 110ms | 71ms | 43ms | 50ms | 365ms | 159ms |
| Palindrome Check | 1112ms | 2269ms | 4597ms | 7554ms | 336ms | 1314ms | 4019ms | 13296ms | 20669ms |
| Polynomial Evaluation | 2559ms | 6464ms | 1494ms | 15773ms | 364ms | 1615ms | 7694ms | 16435ms | 62979ms |
| Power Operation | 1001ms | 714ms | 18270ms | 3102ms | 669ms | 13104ms | 59116ms | 4301ms | 4596ms |
| Prime Count | 116ms | 138ms | 69ms | 165ms | 76ms | 74ms | 161ms | 826ms | 324ms |
| Quick Sort | 59ms | 122ms | 31ms | 160ms | 87ms | 49ms | 89ms | 1281ms | 548ms |
| Sieve of Eratosthenes | 16ms | 35ms | 9ms | 88ms | 63ms | 39ms | 27ms | 371ms | 52ms |
| String Concatenation | 24ms | 74ms | 120ms | 95ms | 81ms | 39ms | 26ms | 309ms | 64ms |
| String Reverse | 33ms | 43ms | 26ms | 107ms | 69ms | 39ms | 39ms | 867ms | 81ms |
| Substring Search | 18ms | 40ms | 16ms | 99ms | 62ms | 38ms | 30ms | 370ms | 46ms |
| Sum of Squares | 70ms | 169ms | 30ms | 152ms | 134ms | 47ms | 67ms | 926ms | 1055ms |
| Vector Dot Product | 130ms | 238ms | 58ms | 210ms | 139ms | 70ms | 170ms | 1217ms | 1327ms |
| Binary Trees | 321ms | 127ms | 168ms | 181ms | 92ms | 94ms | 367ms | 1656ms | 469ms |
| Tak Function | 99ms | 71ms | 45ms | 111ms | 71ms | 56ms | 172ms | 507ms | 221ms |
| Mandelbrot Set | 1106ms | 909ms | 355ms | 1181ms | 99ms | 286ms | 2593ms | 1925ms | 3614ms |
| JSON Serialize | 65ms | 43ms | 43ms | 120ms | 71ms | 43ms | 54ms | 551ms | 53ms |
| K-Nucleotide | 183ms | 115ms | 69ms | 216ms | 118ms | 65ms | 101ms | 1155ms | 159ms |
| Duff's Device | 792ms | 489ms | 152ms | 459ms | 88ms | 210ms | 682ms | 3181ms | 965ms |
| N-Body | 147ms | 117ms | 57ms | 202ms | 82ms | 88ms | 168ms | FAIL | 330ms |
| Fannkuch-Redux | 162ms | 142ms | 39ms | 272ms | 85ms | 83ms | 267ms | 1687ms | 295ms |
| Spectral Norm | 310ms | 245ms | 92ms | 317ms | 84ms | 109ms | 395ms | FAIL | 635ms |
| Fasta | 128ms | 91ms | 50ms | 218ms | 78ms | 65ms | 133ms | 750ms | 518ms |
| Radix Sort | 366ms | 798ms | 247ms | 488ms | 215ms | 221ms | 949ms | 20902ms | 4237ms |
| RK4 Pendulum | 413ms | 1264ms | 379ms | 966ms | 135ms | 295ms | 926ms | 666ms | 5987ms |
| Reverse-Complement | 1206ms | 576ms | 612ms | 1840ms | 376ms | 302ms | 1662ms | FAIL | 2028ms |
| Object Churn | 260ms | 227ms | 140ms | 256ms | 67ms | 90ms | 344ms | 2388ms | 1217ms |
| Method Dispatch | 429ms | 220ms | 94ms | 218ms | 76ms | 97ms | 275ms | 957ms | 984ms |
| Closure Chain | 355ms | 135ms | 59ms | 171ms | 72ms | 89ms | 185ms | 628ms | 844ms |
| Higher-Order Pipeline | 785ms | 426ms | 290ms | 524ms | 157ms | 293ms | 352ms | 7016ms | 2032ms |
| Sort by Comparator | 198ms | 181ms | 78ms | 188ms | 115ms | 89ms | 200ms | 3144ms | 405ms |
| String Pipeline | 190ms | 276ms | 196ms | 281ms | 98ms | 81ms | 152ms | 844ms | 566ms |
| Linked List | 110ms | 166ms | 62ms | 173ms | 105ms | 163ms | 126ms | 2051ms | 488ms |
| Union-Find | 554ms | 528ms | 208ms | 356ms | 161ms | 202ms | 682ms | 3679ms | 2228ms |
| Hash Probe | 112ms | 182ms | 59ms | 144ms | 103ms | 70ms | 148ms | 1478ms | 666ms |
| Exception Ladder | 151ms | 119ms | 48ms | 154ms | 143ms | 69ms | 129ms | 783ms | 652ms |
| Floyd-Warshall | 207ms | 419ms | 82ms | 285ms | 85ms | 117ms | 322ms | 2517ms | 2710ms |
| Game of Life | 1872ms | 2303ms | 676ms | 1669ms | 176ms | 611ms | 1959ms | 15050ms | 14841ms |
| String Sort | 137ms | 97ms | 106ms | 199ms | 98ms | 69ms | 199ms | 1594ms | 199ms |
| Simpson Integration | 548ms | 743ms | 189ms | 659ms | 77ms | 173ms | 948ms | 2940ms | 4013ms |
| Word Count | 234ms | 218ms | 76ms | 264ms | 99ms | 84ms | 171ms | 1886ms | 849ms |
| Trie Dictionary | 285ms | 299ms | 148ms | 302ms | 150ms | 123ms | 335ms | 2273ms | 791ms |
| Miller-Rabin | 37ms | 55ms | 24ms | 98ms | 78ms | 40ms | 41ms | 616ms | 49ms |
| Task Scheduler | 98ms | 198ms | 62ms | 147ms | 86ms | 60ms | 140ms | 941ms | 723ms |
| Mini VM | 73ms | 160ms | 41ms | 125ms | 77ms | 37ms | 100ms | 731ms | 501ms |
| Dijkstra | 437ms | 338ms | 134ms | 412ms | 145ms | 220ms | 525ms | 4987ms | 1121ms |
| LZW Compress | 146ms | 264ms | 73ms | 165ms | 115ms | 74ms | 202ms | 2099ms | 1109ms |
| Pi Digits | 21ms | 31ms | 71ms | 88ms | 62ms | 53ms | 99ms | 388ms | 30ms |
| FFT | 678ms | 1486ms | 297ms | 775ms | 111ms | 210ms | 1138ms | 8811ms | 7625ms |
| LU Decomposition | 424ms | 712ms | 161ms | 600ms | 105ms | 180ms | 429ms | 4194ms | 6061ms |
| **Average** | **372ms** | **451ms** | **706ms** | **707ms** | **124ms** | **466ms** | **2020ms** | **2846ms** | **2703ms** |
| **Success Rate** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** | **96%** | **100%** |

*Note: Debian results were extracted from earlier benchmark runs on the reference Xeon hardware.*

---

## Ubuntu Desktop Environment Benchmarks

These benchmarks were executed on an Ubuntu Desktop machine (current host) to evaluate execution speed, correctness, and cross-platform performance.

**Hardware & OS:**
* **OS:** Ubuntu 22.04.2 LTS x86_64 (Linux 5.15.0-78-generic)
* **CPU:** Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz (8 Cores)
* **RAM:** 16 GB (15 GiB)

**Programming Language Versions:**
* **HudHudScript:** v0.8.0
* **Python:** 3.10.12
* **Lua:** 5.3.6
* **Node.js:** v25.6.0
* **Ruby:** 3.0.2
* **PHP:** 8.1.2
* **Perl:** 5.34.0
* **Raku:** Not found
* **Tcl:** Not found

Below is a summary of the latest benchmark results extracted from `data/benchmark_results.json`. **All times are in milliseconds (ms), and lower is better.**

| Benchmark | HudHud (ms) | Python (ms) | Lua (ms) | Node.js (ms) | Ruby (ms) | PHP (ms) | Perl (ms) | Raku (ms) | Tcl (ms) |
|---|---|---|---|---|---|---|---|---|---|
| [1. Ackermann Function (`ack`)](HUDHUD_SCRIPT_BENCHMARK.md#1-ackermann-function-ack) | 30 | 27 | 6 | 36 | 61 | 17 | 36 | - | - |
| [2. Array Summation (`arrsum`)](HUDHUD_SCRIPT_BENCHMARK.md#2-array-summation-arrsum) | 6 | 13 | 2 | 41 | 53 | 22 | 10 | - | - |
| [3. Breadth-First Search (`bfs`)](HUDHUD_SCRIPT_BENCHMARK.md#3-breadth-first-search-bfs) | 8 | 13 | 2 | 31 | 60 | 13 | 7 | - | - |
| [4. Binary Trees (`binary_trees`)](HUDHUD_SCRIPT_BENCHMARK.md#4-binary-trees-binary_trees) | 222 | 130 | 140 | 42 | 110 | 55 | 270 | - | - |
| [5. Binary Search (`bsearch`)](HUDHUD_SCRIPT_BENCHMARK.md#5-binary-search-bsearch) | 37 | 66 | 20 | 35 | 76 | 17 | 25 | - | - |
| [6. Bubble Sort (`bubble`)](HUDHUD_SCRIPT_BENCHMARK.md#6-bubble-sort-bubble) | 34 | 64 | 10 | 30 | 72 | 20 | 35 | - | - |
| [7. Collatz Sequences (`collatz`)](HUDHUD_SCRIPT_BENCHMARK.md#7-collatz-sequences-collatz) | 146 | 192 | 38 | 37 | 114 | 46 | 101 | - | - |
| [8. Count Set Bits (`count_set_bits`)](HUDHUD_SCRIPT_BENCHMARK.md#8-count-set-bits-count_set_bits) | 149 | 291 | 74 | 49 | 291 | 74 | 188 | - | - |
| [9. Cumulative Sum (`cumulative_sum`)](HUDHUD_SCRIPT_BENCHMARK.md#9-cumulative-sum-cumulative_sum) | 28 | 43 | 7 | 39 | 66 | 18 | 20 | - | - |
| [10. Depth-First Search (`dfs`)](HUDHUD_SCRIPT_BENCHMARK.md#10-depth-first-search-dfs) | 6 | 14 | 2 | 34 | 53 | 12 | 7 | - | - |
| [11. Duff's Device-Style Copy (`duffs_device`)](HUDHUD_SCRIPT_BENCHMARK.md#11-duff's-device-style-copy-duffs_device) | 1665 | 618 | 583 | 140 | 335 | 414 | 747 | - | - |
| [12. Iterative Factorial (`fact`)](HUDHUD_SCRIPT_BENCHMARK.md#12-iterative-factorial-fact) | 22 | 42 | 1106 | 50 | 99 | 1195 | 4428 | - | - |
| [13. Recursive Factorial (`factorial_recursive`)](HUDHUD_SCRIPT_BENCHMARK.md#13-recursive-factorial-factorial_recursive) | 4 | 11 | 1 | 30 | 54 | 15 | 9 | - | - |
| [14. Fannkuch Redux (`fannkuch_redux`)](HUDHUD_SCRIPT_BENCHMARK.md#14-fannkuch-redux-fannkuch_redux) | 174 | 145 | 47 | 36 | 150 | 42 | 169 | - | - |
| [15. FASTA Generation (`fasta`)](HUDHUD_SCRIPT_BENCHMARK.md#15-fasta-generation-fasta) | 106 | 75 | 30 | 37 | 138 | 33 | 85 | - | - |
| [16. Recursive Fibonacci (`fib`)](HUDHUD_SCRIPT_BENCHMARK.md#16-recursive-fibonacci-fib) | 306 | 288 | 130 | 49 | 131 | 72 | 475 | - | - |
| [17. Iterative Fibonacci (`fib_iterative`)](HUDHUD_SCRIPT_BENCHMARK.md#17-iterative-fibonacci-fib_iterative) | 1605 | 668 | 13369 | 237 | 1886 | 7317 | 34168 | - | - |
| [18. Fibonacci Table Construction (`fib_memo`)](HUDHUD_SCRIPT_BENCHMARK.md#18-fibonacci-table-construction-fib_memo) | 1955 | 1385 | 4563 | 189 | 1265 | 2218 | 11031 | - | - |
| [19. Euclidean Greatest Common Divisor (`gcd`)](HUDHUD_SCRIPT_BENCHMARK.md#19-euclidean-greatest-common-divisor-gcd) | 15 | 20 | 5 | 30 | 52 | 14 | 20 | - | - |
| [20. Geometric Series (`geometric_series`)](HUDHUD_SCRIPT_BENCHMARK.md#20-geometric-series-geometric_series) | 93 | 132 | 21 | 40 | 147 | 32 | 56 | - | - |
| [21. Tower of Hanoi (`hanoi`)](HUDHUD_SCRIPT_BENCHMARK.md#21-tower-of-hanoi-hanoi) | 103 | 95 | 35 | 32 | 79 | 31 | 151 | - | - |
| [22. Heap Sort (`heap_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#22-heap-sort-heap_sort) | 7 | 13 | 3 | 34 | 47 | 10 | 9 | - | - |
| [23. Insertion Sort (`insertion_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#23-insertion-sort-insertion_sort) | 55 | 111 | 19 | 31 | 65 | 24 | 46 | - | - |
| [24. K-Nucleotide Frequencies (`k_nucleotide`)](HUDHUD_SCRIPT_BENCHMARK.md#24-k-nucleotide-frequencies-k_nucleotide) | 1341 | 111 | 37 | 58 | 134 | 31 | 59 | - | - |
| [25. 0/1 Knapsack (`knapsack`)](HUDHUD_SCRIPT_BENCHMARK.md#25-01-knapsack-knapsack) | 5 | 14 | 2 | 30 | 46 | 12 | 7 | - | - |
| [26. Longest Common Subsequence (`lcs`)](HUDHUD_SCRIPT_BENCHMARK.md#26-longest-common-subsequence-lcs) | 7 | 14 | 3 | 29 | 52 | 12 | 9 | - | - |
| [27. Mandelbrot Set (`mandelbrot`)](HUDHUD_SCRIPT_BENCHMARK.md#27-mandelbrot-set-mandelbrot) | 1123 | 1116 | 313 | 53 | 851 | 280 | 1906 | - | - |
| [28. Matrix Multiplication (`matrix`)](HUDHUD_SCRIPT_BENCHMARK.md#28-matrix-multiplication-matrix) | 393 | 911 | 207 | 50 | 469 | 126 | 271 | - | - |
| [29. Matrix Transpose (`matrix_transpose`)](HUDHUD_SCRIPT_BENCHMARK.md#29-matrix-transpose-matrix_transpose) | 20 | 33 | 11 | 37 | 66 | 21 | 27 | - | - |
| [30. Mean and Variance (`mean_variance`)](HUDHUD_SCRIPT_BENCHMARK.md#30-mean-and-variance-mean_variance) | 309 | 282 | 51 | 64 | 179 | 76 | 260 | - | - |
| [31. Merge Sort (`merge`)](HUDHUD_SCRIPT_BENCHMARK.md#31-merge-sort-merge) | 7 | 14 | 2 | 29 | 48 | 10 | 7 | - | - |
| [32. Modular Exponentiation (`modular_exp`)](HUDHUD_SCRIPT_BENCHMARK.md#32-modular-exponentiation-modular_exp) | 19 | 29 | 10 | 40 | 54 | 16 | 22 | - | - |
| [33. Monte Carlo Pi (`monte_carlo_pi`)](HUDHUD_SCRIPT_BENCHMARK.md#33-monte-carlo-pi-monte_carlo_pi) | 201 | 325 | 65 | 63 | 166 | 62 | 172 | - | - |
| [34. N-Body Simulation (`n_body`)](HUDHUD_SCRIPT_BENCHMARK.md#34-n-body-simulation-n_body) | 154 | 113 | 43 | 36 | 132 | 53 | 132 | - | - |
| [35. Eight Queens (`n_queens`)](HUDHUD_SCRIPT_BENCHMARK.md#35-eight-queens-n_queens) | 13 | 28 | 4 | 29 | 50 | 13 | 13 | - | - |
| [36. Newton Square Roots (`newton_sqrt`)](HUDHUD_SCRIPT_BENCHMARK.md#36-newton-square-roots-newton_sqrt) | 19 | 24 | 4 | 32 | 63 | 15 | 20 | - | - |
| [37. Palindrome Check (`palindrome`)](HUDHUD_SCRIPT_BENCHMARK.md#37-palindrome-check-palindrome) | 2016 | 2597 | 3410 | 168 | 4539 | 804 | 2840 | - | - |
| [38. Polynomial Evaluation (`polynomial_eval`)](HUDHUD_SCRIPT_BENCHMARK.md#38-polynomial-evaluation-polynomial_eval) | 5320 | 5904 | 2162 | 269 | 11691 | 1337 | 6733 | - | - |
| [39. Repeated Power (`power`)](HUDHUD_SCRIPT_BENCHMARK.md#39-repeated-power-power) | 1493 | 670 | 15440 | 414 | 2330 | 10438 | 45292 | - | - |
| [40. Prime Count by Trial Division (`prime_count`)](HUDHUD_SCRIPT_BENCHMARK.md#40-prime-count-by-trial-division-prime_count) | 122 | 227 | 46 | 34 | 100 | 37 | 99 | - | - |
| [41. Iterative Quick Sort (`quick`)](HUDHUD_SCRIPT_BENCHMARK.md#41-iterative-quick-sort-quick) | 45 | 86 | 14 | 43 | 88 | 19 | 49 | - | - |
| [42. Reverse Complement (`revcomp`)](HUDHUD_SCRIPT_BENCHMARK.md#42-reverse-complement-revcomp) | 866 | 543 | 469 | 241 | 1311 | 236 | 1300 | - | - |
| [43. Sieve of Eratosthenes (`sieve`)](HUDHUD_SCRIPT_BENCHMARK.md#43-sieve-of-eratosthenes-sieve) | 6 | 12 | 2 | 28 | 47 | 11 | 7 | - | - |
| [44. Spectral Norm (`spectral_norm`)](HUDHUD_SCRIPT_BENCHMARK.md#44-spectral-norm-spectral_norm) | 371 | 234 | 73 | 36 | 192 | 69 | 270 | - | - |
| [45. String Concatenation (`strcat`)](HUDHUD_SCRIPT_BENCHMARK.md#45-string-concatenation-strcat) | 7 | 17 | 78 | 33 | 204 | 12 | 6 | - | - |
| [46. String Reverse (`strrev`)](HUDHUD_SCRIPT_BENCHMARK.md#46-string-reverse-strrev) | 108 | 17 | 82 | 30 | 206 | 14 | 10 | - | - |
| [47. Naive Substring Search (`substring_search`)](HUDHUD_SCRIPT_BENCHMARK.md#47-naive-substring-search-substring_search) | 9 | 13 | 4 | 31 | 55 | 11 | 8 | - | - |
| [48. Sum of Squares (`sum_of_squares`)](HUDHUD_SCRIPT_BENCHMARK.md#48-sum-of-squares-sum_of_squares) | 61 | 114 | 10 | 73 | 92 | 18 | 38 | - | - |
| [49. Takeuchi Function (`tak`)](HUDHUD_SCRIPT_BENCHMARK.md#49-takeuchi-function-tak) | 65 | 56 | 22 | 34 | 64 | 25 | 107 | - | - |
| [50. Vector Dot Product (`vector_dot`)](HUDHUD_SCRIPT_BENCHMARK.md#50-vector-dot-product-vector_dot) | 119 | 184 | 31 | 68 | 131 | 53 | 104 | - | - |
| **Average** | **420ms** | **363ms** | **856ms** | **67ms** | **575ms** | **510ms** | **2237ms** | **-** | **-** |
| **Success** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** | **0%** | **0%** |

*Note: Ubuntu results were extracted from recent benchmark runs on this machine.*

## Windows Environment Benchmarks

These benchmarks were run on a Windows machine to verify cross-platform performance.

**Configuration:**
- **OS:** Microsoft Windows 10 Pro (64-bit)
- **CPU:** 11th Gen Intel(R) Core(TM) i7-11700 @ 2.50GHz
- **Versions:** HudHud 0.8.0, Node.js v22.22.1, Python 3.11.15

| Benchmark | hudhud | python | nodejs | ruby |
| :--- | :--- | :--- | :--- | :--- |
| [1. Ackermann Function (`ack`)](HUDHUD_SCRIPT_BENCHMARK.md#1-ackermann-function-ack) | 40ms | 71ms | 62ms | 143ms |
| [2. Array Summation (`arrsum`)](HUDHUD_SCRIPT_BENCHMARK.md#2-array-summation-arrsum) | 31ms | 72ms | 62ms | 142ms |
| [3. Breadth-First Search (`bfs`)](HUDHUD_SCRIPT_BENCHMARK.md#3-breadth-first-search-bfs) | 27ms | 57ms | 58ms | 137ms |
| [5. Binary Search (`bsearch`)](HUDHUD_SCRIPT_BENCHMARK.md#5-binary-search-bsearch) | 47ms | 83ms | 64ms | 151ms |
| [6. Bubble Sort (`bubble`)](HUDHUD_SCRIPT_BENCHMARK.md#6-bubble-sort-bubble) | 50ms | 94ms | 62ms | 154ms |
| [7. Collatz Sequences (`collatz`)](HUDHUD_SCRIPT_BENCHMARK.md#7-collatz-sequences-collatz) | 93ms | 143ms | 62ms | 161ms |
| [8. Count Set Bits (`count_set_bits`)](HUDHUD_SCRIPT_BENCHMARK.md#8-count-set-bits-count_set_bits) | 130ms | 206ms | 79ms | 258ms |
| [9. Cumulative Sum (`cumulative_sum`)](HUDHUD_SCRIPT_BENCHMARK.md#9-cumulative-sum-cumulative_sum) | 38ms | 74ms | 69ms | 157ms |
| [10. Depth-First Search (`dfs`)](HUDHUD_SCRIPT_BENCHMARK.md#10-depth-first-search-dfs) | 30ms | 59ms | 58ms | 145ms |
| [12. Iterative Factorial (`fact`)](HUDHUD_SCRIPT_BENCHMARK.md#12-iterative-factorial-fact) | 46ms | 89ms | 93ms | 203ms |
| [13. Recursive Factorial (`factorial_recursive`)](HUDHUD_SCRIPT_BENCHMARK.md#13-recursive-factorial-factorial_recursive) | 25ms | 55ms | 61ms | 141ms |
| [16. Recursive Fibonacci (`fib`)](HUDHUD_SCRIPT_BENCHMARK.md#16-recursive-fibonacci-fib) | 220ms | 182ms | 63ms | 197ms |
| [17. Iterative Fibonacci (`fib_iterative`)](HUDHUD_SCRIPT_BENCHMARK.md#17-iterative-fibonacci-fib_iterative) | 1064ms | 454ms | 368ms | 1071ms |
| [18. Fibonacci Table Construction (`fib_memo`)](HUDHUD_SCRIPT_BENCHMARK.md#18-fibonacci-table-construction-fib_memo) | 1320ms | 992ms | 270ms | 978ms |
| [19. Euclidean Greatest Common Divisor (`gcd`)](HUDHUD_SCRIPT_BENCHMARK.md#19-euclidean-greatest-common-divisor-gcd) | 34ms | 62ms | 58ms | 142ms |
| [20. Geometric Series (`geometric_series`)](HUDHUD_SCRIPT_BENCHMARK.md#20-geometric-series-geometric_series) | 98ms | 152ms | 74ms | 221ms |
| [21. Tower of Hanoi (`hanoi`)](HUDHUD_SCRIPT_BENCHMARK.md#21-tower-of-hanoi-hanoi) | 113ms | 110ms | 62ms | 168ms |
| [22. Heap Sort (`heap_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#22-heap-sort-heap_sort) | 28ms | 59ms | 59ms | 147ms |
| [23. Insertion Sort (`insertion_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#23-insertion-sort-insertion_sort) | 69ms | 113ms | 61ms | 151ms |
| [25. 0/1 Knapsack (`knapsack`)](HUDHUD_SCRIPT_BENCHMARK.md#25-01-knapsack-knapsack) | 25ms | 55ms | 58ms | 142ms |
| [26. Longest Common Subsequence (`lcs`)](HUDHUD_SCRIPT_BENCHMARK.md#26-longest-common-subsequence-lcs) | 30ms | 57ms | 61ms | 148ms |
| [28. Matrix Multiplication (`matrix`)](HUDHUD_SCRIPT_BENCHMARK.md#28-matrix-multiplication-matrix) | 395ms | 587ms | 81ms | 437ms |
| [29. Matrix Transpose (`matrix_transpose`)](HUDHUD_SCRIPT_BENCHMARK.md#29-matrix-transpose-matrix_transpose) | 42ms | 73ms | 66ms | 152ms |
| [30. Mean and Variance (`mean_variance`)](HUDHUD_SCRIPT_BENCHMARK.md#30-mean-and-variance-mean_variance) | 276ms | 271ms | 84ms | 305ms |
| [31. Merge Sort (`merge`)](HUDHUD_SCRIPT_BENCHMARK.md#31-merge-sort-merge) | 30ms | 59ms | 59ms | 143ms |
| [32. Modular Exponentiation (`modular_exp`)](HUDHUD_SCRIPT_BENCHMARK.md#32-modular-exponentiation-modular_exp) | 38ms | 66ms | 66ms | 160ms |
| [33. Monte Carlo Pi (`monte_carlo_pi`)](HUDHUD_SCRIPT_BENCHMARK.md#33-monte-carlo-pi-monte_carlo_pi) | 203ms | 317ms | 82ms | 388ms |
| [35. Eight Queens (`n_queens`)](HUDHUD_SCRIPT_BENCHMARK.md#35-eight-queens-n_queens) | 33ms | 66ms | 62ms | 143ms |
| [36. Newton Square Roots (`newton_sqrt`)](HUDHUD_SCRIPT_BENCHMARK.md#36-newton-square-roots-newton_sqrt) | 41ms | 66ms | 74ms | 153ms |
| [37. Palindrome Check (`palindrome`)](HUDHUD_SCRIPT_BENCHMARK.md#37-palindrome-check-palindrome) | 1841ms | 1539ms | 183ms | 3365ms |
| [38. Polynomial Evaluation (`polynomial_eval`)](HUDHUD_SCRIPT_BENCHMARK.md#38-polynomial-evaluation-polynomial_eval) | 4590ms | 3954ms | 252ms | 8753ms |
| [39. Repeated Power (`power`)](HUDHUD_SCRIPT_BENCHMARK.md#39-repeated-power-power) | 1124ms | 592ms | 586ms | 1364ms |
| [40. Prime Count by Trial Division (`prime_count`)](HUDHUD_SCRIPT_BENCHMARK.md#40-prime-count-by-trial-division-prime_count) | 126ms | 186ms | 63ms | 174ms |
| [41. Iterative Quick Sort (`quick`)](HUDHUD_SCRIPT_BENCHMARK.md#41-iterative-quick-sort-quick) | 62ms | 108ms | 71ms | 179ms |
| [43. Sieve of Eratosthenes (`sieve`)](HUDHUD_SCRIPT_BENCHMARK.md#43-sieve-of-eratosthenes-sieve) | 29ms | 57ms | 60ms | 139ms |
| [45. String Concatenation (`strcat`)](HUDHUD_SCRIPT_BENCHMARK.md#45-string-concatenation-strcat) | 28ms | 85ms | 64ms | 638ms |
| [46. String Reverse (`strrev`)](HUDHUD_SCRIPT_BENCHMARK.md#46-string-reverse-strrev) | 122ms | 88ms | 65ms | 630ms |
| [47. Naive Substring Search (`substring_search`)](HUDHUD_SCRIPT_BENCHMARK.md#47-naive-substring-search-substring_search) | 29ms | 61ms | 60ms | 149ms |
| [48. Sum of Squares (`sum_of_squares`)](HUDHUD_SCRIPT_BENCHMARK.md#48-sum-of-squares-sum_of_squares) | 75ms | 136ms | 98ms | 263ms |
| [50. Vector Dot Product (`vector_dot`)](HUDHUD_SCRIPT_BENCHMARK.md#50-vector-dot-product-vector_dot) | 125ms | 183ms | 86ms | 249ms |
| [4. Binary Trees (`binary_trees`)](HUDHUD_SCRIPT_BENCHMARK.md#4-binary-trees-binary_trees) | 259ms | 131ms | 67ms | 190ms |
| [49. Takeuchi Function (`tak`)](HUDHUD_SCRIPT_BENCHMARK.md#49-takeuchi-function-tak) | 84ms | 86ms | 61ms | 151ms |
| [27. Mandelbrot Set (`mandelbrot`)](HUDHUD_SCRIPT_BENCHMARK.md#27-mandelbrot-set-mandelbrot) | 864ms | 778ms | 80ms | 807ms |
| [24. K-Nucleotide Frequencies (`k_nucleotide`)](HUDHUD_SCRIPT_BENCHMARK.md#24-k-nucleotide-frequencies-k_nucleotide) | 1169ms | 115ms | 83ms | 233ms |
| [11. Duff's Device-Style Copy (`duffs_device`)](HUDHUD_SCRIPT_BENCHMARK.md#11-duffs-device-style-copy-duffs_device) | 1317ms | 386ms | 148ms | 357ms |
| [34. N-Body Simulation (`n_body`)](HUDHUD_SCRIPT_BENCHMARK.md#34-n-body-simulation-n_body) | 144ms | 129ms | 80ms | 205ms |
| [14. Fannkuch Redux (`fannkuch_redux`)](HUDHUD_SCRIPT_BENCHMARK.md#14-fannkuch-redux-fannkuch_redux) | 155ms | 137ms | 65ms | 237ms |
| [44. Spectral Norm (`spectral_norm`)](HUDHUD_SCRIPT_BENCHMARK.md#44-spectral-norm-spectral_norm) | 360ms | 212ms | 64ms | 241ms |
| [15. FASTA Generation (`fasta`)](HUDHUD_SCRIPT_BENCHMARK.md#15-fasta-generation-fasta) | 120ms | 99ms | 65ms | 216ms |
| [42. Reverse Complement (`revcomp`)](HUDHUD_SCRIPT_BENCHMARK.md#42-reverse-complement-revcomp) | 729ms | 429ms | 221ms | 1162ms |
| **Average** | **359ms** | **285ms** | **99ms** | **535ms** |
| **Success** | **100%** | **100%** | **100%** | **100%** |
