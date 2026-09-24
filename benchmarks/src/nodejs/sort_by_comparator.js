const N = 20000;
const arr = [];
let seed = 12345;
for (let i = 0; i < N; i++) { seed = (seed * 16807) % 2147483647; arr.push(seed % 1000000); }

function quicksort(a, low, high, cmp) {
    if (low >= high) return;
    const stack = [low, high];
    while (stack.length > 0) {
        const h = stack.pop();
        const l = stack.pop();
        if (l >= h) continue;
        const pivot = a[Math.floor((l + h) / 2)];
        let i2 = l, j2 = h;
        while (i2 <= j2) {
            while (cmp(a[i2], pivot) < 0) i2++;
            while (cmp(a[j2], pivot) > 0) j2--;
            if (i2 <= j2) { const t = a[i2]; a[i2] = a[j2]; a[j2] = t; i2++; j2--; }
        }
        if (l < j2) { stack.push(l); stack.push(j2); }
        if (i2 < h) { stack.push(i2); stack.push(h); }
    }
}
const asc = (a,b) => a - b;
const desc = (a,b) => b - a;

const start = Date.now();
const copy1 = [...arr]; quicksort(copy1, 0, N-1, asc);
const copy2 = [...arr]; quicksort(copy2, 0, N-1, desc);
let c1 = 0, c2 = 0;
for (let i = 0; i < N; i++) { c1 = (c1 + copy1[i] * (i % 7)) % 1000003; c2 = (c2 + copy2[i] * (i % 7)) % 1000003; }
const end = Date.now();
console.log("Result: " + c1 + "_" + c2);
console.log("Time: " + Math.floor(end - start) + "ms");
