const start = Date.now();

let seed = 42;
function rand(max_val) {
    seed = (seed * 3877 + 29573) % 139968;
    return max_val * seed / 139968.0;
}

const alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

const iub = [
    {c: "a", p: 0.27}, {c: "c", p: 0.12}, {c: "g", p: 0.12}, {c: "t", p: 0.27},
    {c: "B", p: 0.02}, {c: "D", p: 0.02}, {c: "H", p: 0.02}, {c: "K", p: 0.02},
    {c: "M", p: 0.02}, {c: "N", p: 0.02}, {c: "R", p: 0.02}, {c: "S", p: 0.02},
    {c: "V", p: 0.02}, {c: "W", p: 0.02}, {c: "Y", p: 0.02}
];

let cp = 0.0;
for (let i = 0; i < iub.length; i++) {
    cp += iub[i].p;
    iub[i].p = cp;
}

let res = 0;
const n = 50000;

let total = n * 2;
while (total > 0) {
    const chunk = Math.min(60, total);
    res += chunk;
    total -= chunk;
}

total = n * 3;
while (total > 0) {
    const chunk = Math.min(60, total);
    for (let c = 0; c < chunk; c++) {
        const r = rand(1.0);
        for (let j = 0; j < iub.length; j++) {
            if (r < iub[j].p) {
                res++;
                break;
            }
        }
    }
    total -= chunk;
}

const end = Date.now();
console.log(`Result: ${res}`);
console.log(`Time: ${end - start}ms`);
