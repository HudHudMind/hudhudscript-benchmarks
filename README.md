# HudHudScript Benchmarks (v0.8.219)

This repository contains the official benchmark suite for **HudHudScript v0.8.0**, comparing its execution performance against several popular programming languages including Python, Lua, Node.js, Ruby, PHP, and Perl.

The suite runs a variety of algorithms (sorting, mathematical functions, string manipulation, and classical benchmark problems) across all languages, tracking and storing the average execution times.

All binaries of hudhud built by using run_benchmarks.py script and the following command is used. If any of the benchmarks of HudHudScript does not seem right please kepp this in mind.

```bash
cargo build --release -p hudhudscript-cli --bin hudhud
```


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
* **HudHudScript:** v0.8.219
* **Python:** 3.10.12
* **Lua:** 5.3.6
* **Node.js:** v25.6.0
* **Ruby:** 3.0.2
* **PHP:** 8.1.2
* **Perl:** 5.34.0
* **Raku:** Not found
* **Tcl:** Not found

Below is a summary of the latest benchmark results extracted from `data/benchmark_results.json`. **All times are in milliseconds (ms), and lower is better.**


*Note: Ubuntu results were extracted from recent benchmark runs on this machine.*

## Windows Environment Benchmarks

These benchmarks were run on a Windows machine to verify cross-platform performance.

**Configuration:**
- **OS:** Microsoft Windows 10 Pro (64-bit)
- **CPU:** 11th Gen Intel(R) Core(TM) i7-11700 @ 2.50GHz
- **Versions:** HudHud 0.8.219, Node.js v22.22.1, Python 3.11.15


## Kali Linux Benchmarks

**Configuration:**
- **OS:** Kali 2026.1 Linux kali 6.0.0-kali6-amd64
- **CPU:** Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
- **Versions:** HudHud 0.8.219, Node.js v22.22.0, Python 3.13.12


* **HudHudScript:** hudhud 0.8.219
* **Python:** Python 3.13.12
* **Node.js:** v22.22.0

| Benchmark              |    hudhud |    python |    nodejs |
| ---------------------- | --------: | --------: | --------: |
| Ackermann Function     |      18ms |      28ms |     108ms |
| AVL Insert             |    2069ms |    1075ms |     194ms |
| Array Summation        |       6ms |      12ms |     112ms |
| BFS Graph              |       5ms |      12ms |     112ms |
| Binary Search          |      29ms |      53ms |     117ms |
| Bubble Sort            |      25ms |      50ms |     143ms |
| Collatz Conjecture     |      43ms |     136ms |     114ms |
| Count Set Bits         |      90ms |     217ms |     118ms |
| Cumulative Sum         |      21ms |      34ms |     124ms |
| DFS Graph              |       5ms |      12ms |     107ms |
| Factorial Iterative    |      20ms |      41ms |     124ms |
| Factorial Recursive    |       5ms |      11ms |     110ms |
| Fibonacci Recursive    |     235ms |     125ms |     122ms |
| Fibonacci Iterative    |     846ms |     452ms |     526ms |
| Fibonacci Memoization  |    1930ms |    1310ms |     427ms |
| Euclidean GCD          |      11ms |      20ms |     116ms |
| Geometric Series       |      48ms |     135ms |     125ms |
| Tower of Hanoi         |     103ms |      62ms |     111ms |
| Heap Sort              |       7ms |      13ms |     110ms |
| Insertion Sort         |      56ms |      90ms |     111ms |
| KMP Search             |    1665ms |    1926ms |     307ms |
| 0/1 Knapsack           |       5ms |      17ms |     101ms |
| LCS                    |       9ms |      13ms |     100ms |
| Matrix Multiply        |     324ms |     720ms |     131ms |
| Matrix Transpose       |      15ms |      29ms |     112ms |
| Mean and Variance      |     183ms |     271ms |     134ms |
| Merge Sort             |       7ms |      14ms |     102ms |
| Modular Exponentiation |      12ms |      27ms |     110ms |
| Monte Carlo Pi         |     159ms |     292ms |     124ms |
| Number Parse           |     471ms |     840ms |     207ms |
| N-Queens               |      13ms |      26ms |     106ms |
| Newton-Raphson Sqrt    |      11ms |      22ms |     106ms |
| Palindrome Check       |     872ms |    1722ms |     302ms |
| Polynomial Evaluation  |    2204ms |    5320ms |     326ms |
| Power Operation        |     750ms |     603ms |     659ms |
| Prime Count            |      72ms |     104ms |     112ms |
| Quick Sort             |      33ms |      74ms |     118ms |
| Sieve of Eratosthenes  |       5ms |      11ms |     107ms |
| String Concatenation   |       6ms |      41ms |     111ms |
| String Reverse         |      11ms |      16ms |     113ms |
| Substring Search       |       6ms |      16ms |     124ms |
| Sum of Squares         |      38ms |     113ms |     154ms |
| Vector Dot Product     |      85ms |     154ms |     145ms |
| Binary Trees           |     206ms |      76ms |     117ms |
| Tak Function           |      60ms |      36ms |     106ms |
| Mandelbrot Set         |     920ms |     634ms |     129ms |
| JSON Serialize         |      31ms |      17ms |     109ms |
| K-Nucleotide           |     128ms |      69ms |     133ms |
| Duff's Device          |     703ms |     404ms |     129ms |
| N-Body                 |     108ms |      69ms |     110ms |
| Fannkuch-Redux         |     110ms |      81ms |     107ms |
| Spectral Norm          |     221ms |     153ms |     107ms |
| Fasta                  |      78ms |      51ms |     104ms |
| Radix Sort             |     269ms |     568ms |     180ms |
| RK4 Pendulum           |     307ms |     954ms |     156ms |
| Reverse-Complement     |     900ms |     395ms |     315ms |
| Object Churn           |     184ms |     155ms |     103ms |
| Method Dispatch        |     302ms |     145ms |     112ms |
| Closure Chain          |     266ms |      75ms |     103ms |
| Higher-Order Pipeline  |     529ms |     315ms |     203ms |
| Sort by Comparator     |     143ms |      89ms |     145ms |
| String Pipeline        |     140ms |     180ms |     127ms |
| Linked List            |      75ms |     102ms |     119ms |
| Union-Find             |     415ms |     460ms |     166ms |
| Hash Probe             |      71ms |     130ms |     133ms |
| Exception Ladder       |     106ms |      64ms |     196ms |
| Floyd-Warshall         |     172ms |     320ms |     131ms |
| Game of Life           |    1603ms |    1875ms |     173ms |
| String Sort            |      92ms |      56ms |     135ms |
| Simpson Integration    |     392ms |     498ms |     115ms |
| Word Count             |     162ms |     175ms |     152ms |
| Trie Dictionary        |     192ms |     190ms |     178ms |
| Miller-Rabin           |      12ms |      26ms |     119ms |
| Task Scheduler         |      83ms |     142ms |     111ms |
| Mini VM                |      37ms |     104ms |     113ms |
| Dijkstra               |     405ms |     288ms |     149ms |
| LZW Compress           |      94ms |     193ms |     138ms |
| Pi Digits              |       7ms |      12ms |     102ms |
| FFT                    |     578ms |    1285ms |     137ms |
| LU Decomposition       |     318ms |     579ms |     148ms |
| **Average**            | **287ms** | **340ms** | **152ms** |
| **Success Rate**       |  **100%** |  **100%** |  **100%** |

