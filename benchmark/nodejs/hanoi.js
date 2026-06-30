function hanoi(n) {
    if (n === 1) {
        return 1;
    }
    return hanoi(n - 1) + 1 + hanoi(n - 1);
}
const start = Date.now();
const moves = hanoi(20);
const end = Date.now();
console.log(`Moves: ${moves}`);
console.log(`Time: ${end - start}ms`);

