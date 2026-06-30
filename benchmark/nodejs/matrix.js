const size = 150;
const a = [];
const b = [];
const c = [];
for (let i = 0; i < size; i++) {
    const row_a = [];
    const row_b = [];
    const row_c = [];
    for (let j = 0; j < size; j++) {
        row_a.push(i + j);
        row_b.push(i - j);
        row_c.push(0);
    }
    a.push(row_a);
    b.push(row_b);
    c.push(row_c);
}

const start = Date.now();
for (let i = 0; i < size; i++) {
    for (let j = 0; j < size; j++) {
        for (let k = 0; k < size; k++) {
            c[i][j] = c[i][j] + a[i][k] * b[k][j];
        }
    }
}
const end = Date.now();
console.log(`Result[0][0]: ${c[0][0]}`);
console.log(`Result[149][149]: ${c[149][149]}`);
console.log(`Time: ${end - start}ms`);

