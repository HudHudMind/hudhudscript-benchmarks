let seed = 12345;
let line = "";
for (let j = 0; j < 40; j++) { seed = (seed * 16807) % 2147483647; let field_num = (seed % 1000) + 100; line += "f" + field_num; if (j < 39) line += ","; }
const R = 10000;
let sum_plen = 0, sum_idx = 0, sum_sub = 0;
const start = Date.now();
for (let r = 0; r < R; r++) {
    const parts = line.split(",");
    for (let k = 0; k < parts.length; k++) {
        sum_plen += parts.length;
        sum_idx += parts[k].indexOf("f");
        const p = parts[k];
        if (p.length >= 4) { sum_sub += p.substring(1, 3).length; }
    }
}
const acc = ((sum_plen % 1000003) + (sum_idx % 1000003) + (sum_sub % 1000003)) % 1000003;
const end = Date.now();
console.log("Result: " + acc);
console.log("Time: " + Math.floor(end - start) + "ms");
