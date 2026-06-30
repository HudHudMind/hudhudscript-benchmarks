const size = 300;
const m = [];
const t = [];
for (let i = 0; i < size; i++) {
    const row_m = [];
    const row_t = [];
    for (let j = 0; j < size; j++) {
        row_m.push(i + j);
        row_t.push(0);
    }
    m.push(row_m);
    t.push(row_t);
}

const start = Date.now();
for (let i = 0; i < size; i++) {
    for (let j = 0; j < size; j++) {
        t[j][i] = m[i][j];
    }
}
const end = Date.now();
console.log(`T[0][0]: ${t[0][0]}`);
console.log(`T[299][299]: ${t[299][299]}`);
console.log(`Time: ${end - start}ms`);

