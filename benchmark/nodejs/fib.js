function fib(n) {
    if (n < 2) return n;
    return fib(n - 1) + fib(n - 2);
}

const start = Date.now();
const result = fib(30);
const end = Date.now();
console.log(`fib(30) = ${result}`);
console.log(`Time: ${end - start}ms`);

