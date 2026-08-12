const N = 100000;
let seed = 12345;
let acc = 0;
const start = Date.now();

let head = null;
for (let i = 0; i < N; i++) { seed = (seed * 16807) % 2147483647; head = { value: seed % 10000, next: head }; }

let prev = null, cur = head;
for (let i = 0; i < N; i++) { const nxt = cur.next; cur.next = prev; prev = cur; cur = nxt; }

let pos = 0, walk = prev;
for (let i = 0; i < N; i++) { acc = (acc + walk.value * pos) % 1000003; pos++; walk = walk.next; }

const end = Date.now();
console.log("Result: " + acc);
console.log("Time: " + Math.floor(end - start) + "ms");
