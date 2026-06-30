function generateDna(length) {
    const chars = "ACGT";
    let seq = "";
    let seed = 42;
    for (let i = 0; i < length; i++) {
        seed = (seed * 1103515245 + 12345) & 0x7fffffff;
        let idx = (seed >> 16) % 4;
        seq += chars[idx];
    }
    return seq;
}

function countFrequencies(dna, k) {
    let freqs = new Map();
    let n = dna.length - k + 1;
    for (let i = 0; i < n; i++) {
        let sub = dna.substr(i, k);
        freqs.set(sub, (freqs.get(sub) || 0) + 1);
    }
    return freqs.size;
}

let start = Date.now();
let dna = generateDna(100000);
let c1 = countFrequencies(dna, 1);
let c2 = countFrequencies(dna, 2);
let c3 = countFrequencies(dna, 3);
let res = c1 + c2 + c3;
let end = Date.now();

console.log("Count: " + res);
console.log("Time: " + Math.floor(end - start) + "ms");
