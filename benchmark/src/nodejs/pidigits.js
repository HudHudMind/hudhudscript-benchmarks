// Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
// Node.js BigInt. D=600. Golden: 2668_6766940513

const D = 600;
const GUARD = 5;
const SCALE = D + 10;

function arctanInv(x) {
    let res = 0n;
    let term = (10n ** BigInt(SCALE)) / BigInt(x);
    const x2 = BigInt(x * x);
    let sign = 1;
    let k = 0;
    while (true) {
        const divisor = BigInt(2 * k + 1);
        const tk = term / divisor;
        if (tk === 0n) break;
        if (sign > 0) res += tk;
        else res -= tk;
        sign = -sign;
        term /= x2;
        k++;
    }
    return res;
}

const start = process.hrtime.bigint();

const a5 = arctanInv(5);
const a239 = arctanInv(239);
const pi = 16n * a5 - 4n * a239;

let s = pi.toString();
if (s.length < D + 10) s = s.padStart(D + 10, '0');
s = s.slice(0, D);

let ds = 0;
for (let i = 0; i < D; i++) ds += parseInt(s[i]);
const lt = s.slice(-10);

const end = process.hrtime.bigint();
const ms = Number((end - start) / 1000000n);
console.log(`Result: ${ds}_${lt}`);
console.log(`Time: ${ms}ms`);
