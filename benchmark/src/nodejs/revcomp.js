const comp = {
    A: "T", C: "G", G: "C", T: "A",
    U: "A", M: "K", R: "Y", W: "W",
    S: "S", Y: "R", K: "M", V: "B",
    H: "D", D: "H", B: "V", N: "N",
    a: "T", c: "G", g: "C", t: "A",
    u: "A", m: "K", r: "Y", w: "W",
    s: "S", y: "R", k: "M", v: "B",
    h: "D", d: "H", b: "V", n: "N"
};

function reverse_complement(seq) {
    let count_A = 0;
    for (let i = seq.length - 1; i >= 0; i--) {
        const c = seq[i];
        const rep = comp[c] || c;
        if (rep === "A") {
            count_A++;
        }
    }
    return count_A;
}

const start = Date.now();

let seq = [];
let seed = 42;
const chars = ["A", "C", "G", "T"];
for (let i = 0; i < 500000; i++) {
    seed = Number((BigInt(seed) * 1103515245n + 12345n) & 0x7fffffffn);
    const idx = (seed >> 16) % 4;
    seq.push(chars[idx]);
}
const seq_str = seq.join("");

let res = 0;
for (let i = 0; i < 10; i++) {
    res = reverse_complement(seq_str);
}

const end = Date.now();

console.log(`Result: ${res}`);
console.log(`Time: ${end - start}ms`);
