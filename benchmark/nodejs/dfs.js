const n = 100;
const adj = [];
for (let i = 0; i < n; i++) {
    const row = [];
    for (let j = 0; j < n; j++) {
        row.push(0);
    }
    adj.push(row);
}
for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
        if ((i * 3 + j * 7) % 11 === 0) {
            if (i !== j) {
                adj[i][j] = 1;
            }
        }
    }
}
const start = Date.now();
const visited = [];
for (let i = 0; i < n; i++) {
    visited.push(false);
}
const stack = [0];
let count = 0;
while (true) {
    if (stack.length === 0) {
        break;
    }
    const node = stack.pop();
    if (!visited[node]) {
        visited[node] = true;
        count = count + 1;
        for (let neighbor = n - 1; neighbor >= 0; neighbor--) {
            if (adj[node][neighbor] === 1) {
                if (!visited[neighbor]) {
                    stack.push(neighbor);
                }
            }
        }
    }
}
const end = Date.now();
console.log(`Visited: ${count}`);
console.log(`Time: ${end - start}ms`);

