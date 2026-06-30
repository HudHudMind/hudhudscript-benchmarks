const start = Date.now();
function mod_exp(base, exp, mod) {
    let result = 1n;
    let b = BigInt(base) % BigInt(mod);
    let e = BigInt(exp);
    const m = BigInt(mod);
    while (e > 0n) {
        if (e % 2n === 1n) {
            result = (result * b) % m;
        }
        b = (b * b) % m;
        e = e / 2n;
    }
    return result;
}
let s = 0n;
for (let i = 0; i < 10000; i++) {
    s += mod_exp(3, 1000, 1000000007);
}
const end = Date.now();
console.log(`Sum: ${s}`);
console.log(`Time: ${end - start}ms`);

