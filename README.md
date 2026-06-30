# HudHudScript Benchmarks (v0.8.0)

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

## System Specifications
The benchmarks were executed on the following hardware and environment to ensure consistency and reliable measurements:

**Hardware & OS:**
* **OS:** Debian GNU/Linux 12 (bookworm) x86_64 (Linux 6.1.0)
* **CPU:** Intel(R) Xeon(R) Silver 4114 CPU @ 2.20GHz (40 Cores / 2 Sockets)
* **RAM:** 32 GB (31 GiB)

**Programming Language Versions:**
* **HudHudScript:** v0.8.0
* **Python:** 3.11.2
* **Lua:** 5.4.4
* **Node.js:** v22.22.2
* **Ruby:** 3.1.2
* **PHP:** 8.2.30
* **Perl:** 5.36.0
* **Raku:** 2022.12
* **Tcl:** 8.6.13

## Benchmark Results

Below is a summary of the latest benchmark results extracted from `data/benchmark_results.json`. **All times are in milliseconds (ms), and lower is better.**

| Benchmark | HudHud (ms) | Python (ms) | Lua (ms) | Node.js (ms) | Ruby (ms) | PHP (ms) | Perl (ms) | Raku (ms) | Tcl (ms) |
|---|---|---|---|---|---|---|---|---|---|
| [1. Ackermann Function (`ack`)](HUDHUD_SCRIPT_BENCHMARK.md#1-ackermann-function-ack) | 44 | 66 | 18 | 61 | 95 | 42 | 64 | 445 | 76 |
| [2. Array Summation (`arrsum`)](HUDHUD_SCRIPT_BENCHMARK.md#2-array-summation-arrsum) | 17 | 35 | 7 | 65 | 89 | 38 | 22 | 315 | 44 |
| [3. Breadth-First Search (`bfs`)](HUDHUD_SCRIPT_BENCHMARK.md#3-breadth-first-search-bfs) | 21 | 33 | 5 | 60 | 84 | 36 | 23 | 408 | 35 |
| [4. Binary Trees (`binary_trees`)](HUDHUD_SCRIPT_BENCHMARK.md#4-binary-trees-binary_trees) | 321 | 127 | 173 | 86 | 169 | 92 | 360 | 1717 | 461 |
| [5. Binary Search (`bsearch`)](HUDHUD_SCRIPT_BENCHMARK.md#5-binary-search-bsearch) | 60 | 84 | 42 | 77 | 107 | 38 | 54 | 547 | 181 |
| [6. Bubble Sort (`bubble`)](HUDHUD_SCRIPT_BENCHMARK.md#6-bubble-sort-bubble) | 63 | 81 | 17 | 73 | 115 | 41 | 63 | 7523 | 4932 |
| [7. Collatz Sequences (`collatz`)](HUDHUD_SCRIPT_BENCHMARK.md#7-collatz-sequences-collatz) | 163 | 170 | 59 | 69 | 143 | 74 | 135 | 684 | 170 |
| [8. Count Set Bits (`count_set_bits`)](HUDHUD_SCRIPT_BENCHMARK.md#8-count-set-bits-count_set_bits) | 189 | 257 | 92 | 81 | 340 | 115 | 232 | 735 | 394 |
| [9. Cumulative Sum (`cumulative_sum`)](HUDHUD_SCRIPT_BENCHMARK.md#9-cumulative-sum-cumulative_sum) | 40 | 59 | 19 | 72 | 94 | 41 | 49 | 543 | 257 |
| [10. Depth-First Search (`dfs`)](HUDHUD_SCRIPT_BENCHMARK.md#10-depth-first-search-dfs) | 21 | 32 | 9 | 63 | 95 | 39 | 23 | 410 | 40 |
| [11. Duff's Device-Style Copy (`duffs_device`)](HUDHUD_SCRIPT_BENCHMARK.md#11-duffs-device-style-copy-duffs_device) | 2330 | 607 | 790 | 248 | 548 | 286 | 1056 | 8791 | 966 |
| [12. Iterative Factorial (`fact`)](HUDHUD_SCRIPT_BENCHMARK.md#12-iterative-factorial-fact) | 53 | 65 | 1119 | 88 | 141 | 1355 | 4934 | 1011 | 2208 |
| [13. Recursive Factorial (`factorial_recursive`)](HUDHUD_SCRIPT_BENCHMARK.md#13-recursive-factorial-factorial_recursive) | 15 | 27 | 6 | 65 | 85 | 35 | 22 | 1313 | 809 |
| [14. Fannkuch Redux (`fannkuch_redux`)](HUDHUD_SCRIPT_BENCHMARK.md#14-fannkuch-redux-fannkuch_redux) | 237 | 148 | 61 | 82 | 266 | 84 | 255 | 1568 | 285 |
| [15. FASTA Generation (`fasta`)](HUDHUD_SCRIPT_BENCHMARK.md#15-fasta-generation-fasta) | 157 | 90 | 51 | 72 | 200 | 63 | 133 | 732 | 516 |
| [16. Recursive Fibonacci (`fib`)](HUDHUD_SCRIPT_BENCHMARK.md#16-recursive-fibonacci-fib) | 335 | 175 | 118 | 79 | 181 | 97 | 538 | 1226 | 792 |
| [17. Iterative Fibonacci (`fib_iterative`)](HUDHUD_SCRIPT_BENCHMARK.md#17-iterative-fibonacci-fib_iterative) | 1576 | 612 | 13753 | 490 | 2327 | 7932 | 40402 | - | 4075 |
| [18. Fibonacci Table Construction (`fib_memo`)](HUDHUD_SCRIPT_BENCHMARK.md#18-fibonacci-table-construction-fib_memo) | 2273 | 1876 | 5586 | 355 | 1798 | 2671 | 14743 | 19230 | 7196 |
| [19. Euclidean Greatest Common Divisor (`gcd`)](HUDHUD_SCRIPT_BENCHMARK.md#19-euclidean-greatest-common-divisor-gcd) | 39 | 38 | 16 | 68 | 84 | 42 | 49 | 433 | 84 |
| [20. Geometric Series (`geometric_series`)](HUDHUD_SCRIPT_BENCHMARK.md#20-geometric-series-geometric_series) | 131 | 193 | 39 | 76 | 232 | 67 | 103 | 548 | 1238 |
| [21. Tower of Hanoi (`hanoi`)](HUDHUD_SCRIPT_BENCHMARK.md#21-tower-of-hanoi-hanoi) | 158 | 97 | 60 | 68 | 124 | 64 | 224 | 297 | 14 |
| [22. Heap Sort (`heap_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#22-heap-sort-heap_sort) | 23 | 29 | 7 | 71 | 86 | 31 | 26 | 2577 | 856 |
| [23. Insertion Sort (`insertion_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#23-insertion-sort-insertion_sort) | 94 | 114 | 31 | 74 | 111 | 46 | 74 | 1645 | 963 |
| [24. K-Nucleotide Frequencies (`k_nucleotide`)](HUDHUD_SCRIPT_BENCHMARK.md#24-k-nucleotide-frequencies-k_nucleotide) | 1960 | 107 | 71 | 110 | 209 | 59 | 102 | 1157 | 155 |
| [25. 0/1 Knapsack (`knapsack`)](HUDHUD_SCRIPT_BENCHMARK.md#25-01-knapsack-knapsack) | 18 | 35 | 6 | 62 | 83 | 35 | 22 | 523 | 61 |
| [26. Longest Common Subsequence (`lcs`)](HUDHUD_SCRIPT_BENCHMARK.md#26-longest-common-subsequence-lcs) | 23 | 31 | 12 | 76 | 91 | 38 | 29 | 634 | 122 |
| [27. Mandelbrot Set (`mandelbrot`)](HUDHUD_SCRIPT_BENCHMARK.md#27-mandelbrot-set-mandelbrot) | 1332 | 899 | 351 | 92 | 1182 | 290 | 2528 | 1787 | 3550 |
| [28. Matrix Multiplication (`matrix`)](HUDHUD_SCRIPT_BENCHMARK.md#28-matrix-multiplication-matrix) | 529 | 920 | 183 | 116 | 705 | 156 | 422 | 3769 | 5763 |
| [29. Matrix Transpose (`matrix_transpose`)](HUDHUD_SCRIPT_BENCHMARK.md#29-matrix-transpose-matrix_transpose) | 49 | 61 | 20 | 78 | 111 | 41 | 59 | 44804 | 82559 |
| [30. Mean and Variance (`mean_variance`)](HUDHUD_SCRIPT_BENCHMARK.md#30-mean-and-variance-mean_variance) | 403 | 397 | 62 | 110 | 282 | 90 | 406 | 424161 | 25024 |
| [31. Merge Sort (`merge`)](HUDHUD_SCRIPT_BENCHMARK.md#31-merge-sort-merge) | 25 | 37 | 9 | 67 | 87 | 37 | 28 | - | - |
| [32. Modular Exponentiation (`modular_exp`)](HUDHUD_SCRIPT_BENCHMARK.md#32-modular-exponentiation-modular_exp) | 43 | 54 | 29 | 77 | 95 | 45 | 57 | - | 65 |
| [33. Monte Carlo Pi (`monte_carlo_pi`)](HUDHUD_SCRIPT_BENCHMARK.md#33-monte-carlo-pi-monte_carlo_pi) | 280 | 390 | 79 | 111 | 259 | 111 | 258 | 2113 | 1188 |
| [34. N-Body Simulation (`n_body`)](HUDHUD_SCRIPT_BENCHMARK.md#34-n-body-simulation-n_body) | 226 | 121 | 51 | 81 | 211 | 89 | 180 | 1943 | 328 |
| [35. Eight Queens (`n_queens`)](HUDHUD_SCRIPT_BENCHMARK.md#35-eight-queens-n_queens) | 37 | 53 | 14 | 68 | 91 | 41 | 39 | 2247 | 692 |
| [36. Newton Square Roots (`newton_sqrt`)](HUDHUD_SCRIPT_BENCHMARK.md#36-newton-square-roots-newton_sqrt) | 49 | 52 | 15 | 62 | 111 | 42 | 42 | 742 | 471 |
| [37. Palindrome Check (`palindrome`)](HUDHUD_SCRIPT_BENCHMARK.md#37-palindrome-check-palindrome) | 2779 | 2224 | 4594 | 333 | 7344 | 1279 | 4050 | 24767 | 11619 |
| [38. Polynomial Evaluation (`polynomial_eval`)](HUDHUD_SCRIPT_BENCHMARK.md#38-polynomial-evaluation-polynomial_eval) | 7205 | 6335 | 1456 | 362 | 15591 | 1575 | 7374 | 49169 | 14770 |
| [39. Repeated Power (`power`)](HUDHUD_SCRIPT_BENCHMARK.md#39-repeated-power-power) | 1682 | 696 | 17549 | 654 | 3038 | 13072 | 58115 | 318 | 38 |
| [40. Prime Count by Trial Division (`prime_count`)](HUDHUD_SCRIPT_BENCHMARK.md#40-prime-count-by-trial-division-prime_count) | 178 | 244 | 68 | 73 | 153 | 65 | 158 | - | 314 |
| [41. Iterative Quick Sort (`quick`)](HUDHUD_SCRIPT_BENCHMARK.md#41-iterative-quick-sort-quick) | 81 | 110 | 22 | 86 | 153 | 49 | 82 | - | 8309 |
| [42. Reverse Complement (`revcomp`)](HUDHUD_SCRIPT_BENCHMARK.md#42-reverse-complement-revcomp) | 1148 | 562 | 584 | 369 | 1800 | 285 | 1628 | 5369 | 1931 |
| [43. Sieve of Eratosthenes (`sieve`)](HUDHUD_SCRIPT_BENCHMARK.md#43-sieve-of-eratosthenes-sieve) | 21 | 34 | 6 | 63 | 86 | 37 | 21 | 1353 | 844 |
| [44. Spectral Norm (`spectral_norm`)](HUDHUD_SCRIPT_BENCHMARK.md#44-spectral-norm-spectral_norm) | 524 | 233 | 93 | 76 | 306 | 103 | 384 | 2169 | 639 |
| [45. String Concatenation (`strcat`)](HUDHUD_SCRIPT_BENCHMARK.md#45-string-concatenation-strcat) | 25 | 69 | 112 | 79 | 410 | 39 | 24 | 312 | 62 |
| [46. String Reverse (`strrev`)](HUDHUD_SCRIPT_BENCHMARK.md#46-string-reverse-strrev) | 229 | 75 | 81 | 84 | 394 | 39 | 28 | 345 | 70 |
| [47. Naive Substring Search (`substring_search`)](HUDHUD_SCRIPT_BENCHMARK.md#47-naive-substring-search-substring_search) | 27 | 33 | 13 | 65 | 98 | 36 | 29 | 441 | 37 |
| [48. Sum of Squares (`sum_of_squares`)](HUDHUD_SCRIPT_BENCHMARK.md#48-sum-of-squares-sum_of_squares) | 106 | 171 | 28 | 130 | 146 | 35 | 68 | 910 | 1060 |
| [49. Takeuchi Function (`tak`)](HUDHUD_SCRIPT_BENCHMARK.md#49-takeuchi-function-tak) | 118 | 70 | 45 | 68 | 105 | 57 | 169 | 487 | 214 |
| [50. Vector Dot Product (`vector_dot`)](HUDHUD_SCRIPT_BENCHMARK.md#50-vector-dot-product-vector_dot) | 192 | 241 | 59 | 131 | 208 | 69 | 168 | 1218 | 1306 |
| **Average** | **552** | **385** | **953** | **124** | **817** | **622** | **2801** | **13854** | **3832** |
| **Success** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** | **100%** |

*Note: Results were extracted from recent benchmark runs. The test environment specifics may affect exact reproduction timings.*

## Windows Environment Benchmarks

These benchmarks were run on a Windows machine to verify cross-platform performance.

**Configuration:**
- **OS:** Microsoft Windows 10 Pro (64-bit)
- **CPU:** 11th Gen Intel(R) Core(TM) i7-11700 @ 2.50GHz
- **Versions:** HudHud 0.8.0, Node.js v22.22.1, Python 3.11.15

| Benchmark | hudhud | python | nodejs |
| :--- | :--- | :--- | :--- |
| [1. Ackermann Function (`ack`)](HUDHUD_SCRIPT_BENCHMARK.md#1-ackermann-function-ack) | 46ms | 76ms | 67ms |
| [2. Array Summation (`arrsum`)](HUDHUD_SCRIPT_BENCHMARK.md#2-array-summation-arrsum) | 31ms | 64ms | 62ms |
| [3. Breadth-First Search (`bfs`)](HUDHUD_SCRIPT_BENCHMARK.md#3-breadth-first-search-bfs) | 28ms | 105ms | 68ms |
| [5. Binary Search (`bsearch`)](HUDHUD_SCRIPT_BENCHMARK.md#5-binary-search-bsearch) | 62ms | 93ms | 72ms |
| [6. Bubble Sort (`bubble`)](HUDHUD_SCRIPT_BENCHMARK.md#6-bubble-sort-bubble) | 55ms | 87ms | 62ms |
| [7. Collatz Sequences (`collatz`)](HUDHUD_SCRIPT_BENCHMARK.md#7-collatz-sequences-collatz) | 102ms | 150ms | 75ms |
| [8. Count Set Bits (`count_set_bits`)](HUDHUD_SCRIPT_BENCHMARK.md#8-count-set-bits-count_set_bits) | 128ms | 193ms | 85ms |
| [9. Cumulative Sum (`cumulative_sum`)](HUDHUD_SCRIPT_BENCHMARK.md#9-cumulative-sum-cumulative_sum) | 47ms | 76ms | 72ms |
| [10. Depth-First Search (`dfs`)](HUDHUD_SCRIPT_BENCHMARK.md#10-depth-first-search-dfs) | 29ms | 58ms | 60ms |
| [12. Iterative Factorial (`fact`)](HUDHUD_SCRIPT_BENCHMARK.md#12-iterative-factorial-fact) | 48ms | 93ms | 92ms |
| [13. Recursive Factorial (`factorial_recursive`)](HUDHUD_SCRIPT_BENCHMARK.md#13-recursive-factorial-factorial_recursive) | 28ms | 59ms | 65ms |
| [16. Recursive Fibonacci (`fib`)](HUDHUD_SCRIPT_BENCHMARK.md#16-recursive-fibonacci-fib) | 215ms | 177ms | 94ms |
| [17. Iterative Fibonacci (`fib_iterative`)](HUDHUD_SCRIPT_BENCHMARK.md#17-iterative-fibonacci-fib_iterative) | 1056ms | 444ms | 365ms |
| [18. Fibonacci Table Construction (`fib_memo`)](HUDHUD_SCRIPT_BENCHMARK.md#18-fibonacci-table-construction-fib_memo) | 1243ms | 990ms | 303ms |
| [19. Euclidean Greatest Common Divisor (`gcd`)](HUDHUD_SCRIPT_BENCHMARK.md#19-euclidean-greatest-common-divisor-gcd) | 38ms | 67ms | 63ms |
| [20. Geometric Series (`geometric_series`)](HUDHUD_SCRIPT_BENCHMARK.md#20-geometric-series-geometric_series) | 100ms | 145ms | 73ms |
| [21. Tower of Hanoi (`hanoi`)](HUDHUD_SCRIPT_BENCHMARK.md#21-tower-of-hanoi-hanoi) | 115ms | 107ms | 68ms |
| [22. Heap Sort (`heap_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#22-heap-sort-heap_sort) | 32ms | 59ms | 63ms |
| [23. Insertion Sort (`insertion_sort`)](HUDHUD_SCRIPT_BENCHMARK.md#23-insertion-sort-insertion_sort) | 71ms | 117ms | 68ms |
| [25. 0/1 Knapsack (`knapsack`)](HUDHUD_SCRIPT_BENCHMARK.md#25-01-knapsack-knapsack) | 31ms | 61ms | 62ms |
| [26. Longest Common Subsequence (`lcs`)](HUDHUD_SCRIPT_BENCHMARK.md#26-longest-common-subsequence-lcs) | 30ms | 60ms | 77ms |
| [28. Matrix Multiplication (`matrix`)](HUDHUD_SCRIPT_BENCHMARK.md#28-matrix-multiplication-matrix) | 488ms | 814ms | 97ms |
| [29. Matrix Transpose (`matrix_transpose`)](HUDHUD_SCRIPT_BENCHMARK.md#29-matrix-transpose-matrix_transpose) | 47ms | 90ms | 82ms |
| [30. Mean and Variance (`mean_variance`)](HUDHUD_SCRIPT_BENCHMARK.md#30-mean-and-variance-mean_variance) | 341ms | 321ms | 88ms |
| [31. Merge Sort (`merge`)](HUDHUD_SCRIPT_BENCHMARK.md#31-merge-sort-merge) | 33ms | 132ms | 66ms |
| [32. Modular Exponentiation (`modular_exp`)](HUDHUD_SCRIPT_BENCHMARK.md#32-modular-exponentiation-modular_exp) | 40ms | 70ms | 68ms |
| [33. Monte Carlo Pi (`monte_carlo_pi`)](HUDHUD_SCRIPT_BENCHMARK.md#33-monte-carlo-pi-monte_carlo_pi) | 217ms | 365ms | 92ms |
| [35. Eight Queens (`n_queens`)](HUDHUD_SCRIPT_BENCHMARK.md#35-eight-queens-n_queens) | 37ms | 69ms | 63ms |
| [36. Newton Square Roots (`newton_sqrt`)](HUDHUD_SCRIPT_BENCHMARK.md#36-newton-square-roots-newton_sqrt) | 42ms | 105ms | 86ms |
| [37. Palindrome Check (`palindrome`)](HUDHUD_SCRIPT_BENCHMARK.md#37-palindrome-check-palindrome) | 1875ms | 1673ms | 190ms |
| [38. Polynomial Evaluation (`polynomial_eval`)](HUDHUD_SCRIPT_BENCHMARK.md#38-polynomial-evaluation-polynomial_eval) | 4730ms | 4016ms | 248ms |
| [39. Repeated Power (`power`)](HUDHUD_SCRIPT_BENCHMARK.md#39-repeated-power-power) | 1115ms | 603ms | 589ms |
| [40. Prime Count by Trial Division (`prime_count`)](HUDHUD_SCRIPT_BENCHMARK.md#40-prime-count-by-trial-division-prime_count) | 127ms | 190ms | 64ms |
| [41. Iterative Quick Sort (`quick`)](HUDHUD_SCRIPT_BENCHMARK.md#41-iterative-quick-sort-quick) | 62ms | 111ms | 66ms |
| [43. Sieve of Eratosthenes (`sieve`)](HUDHUD_SCRIPT_BENCHMARK.md#43-sieve-of-eratosthenes-sieve) | 29ms | 58ms | 59ms |
| [45. String Concatenation (`strcat`)](HUDHUD_SCRIPT_BENCHMARK.md#45-string-concatenation-strcat) | 28ms | 88ms | 67ms |
| [46. String Reverse (`strrev`)](HUDHUD_SCRIPT_BENCHMARK.md#46-string-reverse-strrev) | 127ms | 91ms | 68ms |
| [47. Naive Substring Search (`substring_search`)](HUDHUD_SCRIPT_BENCHMARK.md#47-naive-substring-search-substring_search) | 46ms | 62ms | 76ms |
| [48. Sum of Squares (`sum_of_squares`)](HUDHUD_SCRIPT_BENCHMARK.md#48-sum-of-squares-sum_of_squares) | 85ms | 142ms | 104ms |
| [50. Vector Dot Product (`vector_dot`)](HUDHUD_SCRIPT_BENCHMARK.md#50-vector-dot-product-vector_dot) | 123ms | 207ms | 91ms |
| [4. Binary Trees (`binary_trees`)](HUDHUD_SCRIPT_BENCHMARK.md#4-binary-trees-binary_trees) | 260ms | 132ms | 73ms |
| [49. Takeuchi Function (`tak`)](HUDHUD_SCRIPT_BENCHMARK.md#49-takeuchi-function-tak) | 84ms | 84ms | 65ms |
| [27. Mandelbrot Set (`mandelbrot`)](HUDHUD_SCRIPT_BENCHMARK.md#27-mandelbrot-set-mandelbrot) | 848ms | 776ms | 81ms |
| [24. K-Nucleotide Frequencies (`k_nucleotide`)](HUDHUD_SCRIPT_BENCHMARK.md#24-k-nucleotide-frequencies-k_nucleotide) | 1159ms | 113ms | 83ms |
| [11. Duff's Device-Style Copy (`duffs_device`)](HUDHUD_SCRIPT_BENCHMARK.md#11-duffs-device-style-copy-duffs_device) | 1298ms | 481ms | 142ms |
| [34. N-Body Simulation (`n_body`)](HUDHUD_SCRIPT_BENCHMARK.md#34-n-body-simulation-n_body) | 151ms | 134ms | 67ms |
| [14. Fannkuch Redux (`fannkuch_redux`)](HUDHUD_SCRIPT_BENCHMARK.md#14-fannkuch-redux-fannkuch_redux) | 159ms | 150ms | 68ms |
| [44. Spectral Norm (`spectral_norm`)](HUDHUD_SCRIPT_BENCHMARK.md#44-spectral-norm-spectral_norm) | 353ms | 219ms | 70ms |
| [15. FASTA Generation (`fasta`)](HUDHUD_SCRIPT_BENCHMARK.md#15-fasta-generation-fasta) | 128ms | 95ms | 67ms |
| [42. Reverse Complement (`revcomp`)](HUDHUD_SCRIPT_BENCHMARK.md#42-reverse-complement-revcomp) | 718ms | 435ms | 219ms |
| **Average** | **354ms** | **282ms** | **98ms** |
| **Success** | **100%** | **100%** | **100%** |
