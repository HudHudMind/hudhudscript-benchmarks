let seed = 42n;
function rng() {
    seed = (seed * 1103515245n + 12345n) % 2147483648n;
    return Number((seed - (seed % 65536n)) / 65536n) % 4;
}
const chars = "ACGT";
let textArr = [];
for (let i = 0; i < 500000; i++) textArr.push(chars[rng()]);
const text = textArr.join("");

const patterns = [];
for (let i = 0; i < 15; i++) {
    const startPos = Number((seed * 16807n) % 499000n);
    seed = (seed * 16807n) % 2147483647n;
    const plen = 5 + Number(seed % 11n);
    patterns.push(text.substring(startPos, startPos + plen));
}
for (let i = 0; i < 5; i++) {
    const pat = "QQQQQ" + String(Number((seed * 16807n) % 10n));
    seed = (seed * 16807n) % 2147483647n;
    patterns.push(pat);
}

const start = Date.now();
let totalMatches = 0;
for (const pat of patterns) {
    const m = pat.length;
    const fail = new Array(m).fill(0);
    let j = 0;
    for (let i = 1; i < m; i++) {
        while (j > 0 && pat[i] !== pat[j]) j = fail[j - 1];
        if (pat[i] === pat[j]) j++;
        fail[i] = j;
    }
    j = 0;
    for (let i = 0; i < text.length; i++) {
        while (j > 0 && text[i] !== pat[j]) j = fail[j - 1];
        if (text[i] === pat[j]) j++;
        if (j === m) { totalMatches++; j = fail[j - 1]; }
    }
}
const end = Date.now();
console.log(`Result: ${totalMatches}`);
console.log(`Time: ${end - start}ms`);
