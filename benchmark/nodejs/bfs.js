const n = 100;
const adj = Array.from({ length: n }, () => Array(n).fill(0));
for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
        if ((i * 3 + j * 7) % 11 === 0 && i !== j) adj[i][j] = 1;
    }
}
const start = Date.now();
const visited = Array(n).fill(false);
const queue = [0];
let head = 0;
let count = 0;
while (head < queue.length) {
    const node = queue[head];
    head++;
    if (visited[node]) continue;
    visited[node] = true;
    count++;
    for (let neighbor = 0; neighbor < n; neighbor++) {
        if (adj[node][neighbor] === 1 && !visited[neighbor]) queue.push(neighbor);
    }
}
const end = Date.now();
console.log(`Visited: ${count}`);
console.log(`Time: ${end - start}ms`);

