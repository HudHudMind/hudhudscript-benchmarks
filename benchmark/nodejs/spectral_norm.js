function eval_A(i, j) {
    return 1.0 / (((i + j) * (i + j + 1) / 2) + i + 1);
}

function eval_A_times_u(u, v, n) {
    for (let i = 0; i < n; i++) {
        v[i] = 0.0;
        for (let j = 0; j < n; j++) {
            v[i] += eval_A(i, j) * u[j];
        }
    }
}

function eval_At_times_u(u, v, n) {
    for (let i = 0; i < n; i++) {
        v[i] = 0.0;
        for (let j = 0; j < n; j++) {
            v[i] += eval_A(j, i) * u[j];
        }
    }
}

function eval_AtA_times_u(u, v, w, n) {
    eval_A_times_u(u, w, n);
    eval_At_times_u(w, v, n);
}

const start = Date.now();
const n = 150;
let u = new Float64Array(n);
let v = new Float64Array(n);
let w = new Float64Array(n);

for (let i = 0; i < n; i++) u[i] = 1.0;

for (let i = 0; i < 10; i++) {
    eval_AtA_times_u(u, v, w, n);
    eval_AtA_times_u(v, u, w, n);
}

let vBv = 0.0;
let vv = 0.0;
for (let i = 0; i < n; i++) {
    vBv += u[i] * v[i];
    vv += v[i] * v[i];
}

const res = Math.sqrt(vBv / vv);
const end = Date.now();

console.log(`Result: ${res.toFixed(9)}`);
console.log(`Time: ${end - start}ms`);
