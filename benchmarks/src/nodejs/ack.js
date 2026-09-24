function ack(m, n) {
    if (m === 0) {
        return n + 1;
    }
    if (n === 0) {
        return ack(m - 1, 1);
    }
    return ack(m - 1, ack(m, n - 1));
}

const start = Date.now();
const result = ack(3, 6);
const end = Date.now();
console.log(`Result: ${result}`);
console.log(`Time: ${end - start}ms`);

