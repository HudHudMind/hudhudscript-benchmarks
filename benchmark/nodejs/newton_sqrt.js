function sqrt_newton(n) {
    if (n === 0) {
        return 0;
    }
    let x = n / 2.0;
    for (let i = 0; i < 20; i++) {
        x = (x + n / x) / 2.0;
    }
    return x;
}

const start = Date.now();
let s = 0.0;
for (let i = 1; i <= 10000; i++) {
    s += sqrt_newton(i);
}
const end = Date.now();
console.log(`Sum: ${s}`);
console.log(`Time: ${end - start}ms`);

