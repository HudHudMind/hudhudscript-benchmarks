const n = 100000;
let seed = 12345;
function ri(m) { seed = (seed * 16807) % 2147483647; return seed % m; }

const sz = n + 10;
const key = new Array(sz).fill(0);
const left = new Array(sz).fill(0);
const right = new Array(sz).fill(0);
const height = new Array(sz).fill(0);
let nodes = 0;

function newNode(k) { nodes++; key[nodes] = k; left[nodes] = 0; right[nodes] = 0; height[nodes] = 1; return nodes; }
function getHeight(node) { return node !== 0 ? height[node] : 0; }
function updateHeight(node) { const hl = getHeight(left[node]); const hr = getHeight(right[node]); height[node] = (hl > hr ? hl : hr) + 1; }
function balance(node) { return getHeight(left[node]) - getHeight(right[node]); }

function rotateRight(y) {
    const x = left[y], T = right[x];
    right[x] = y; left[y] = T;
    updateHeight(y); updateHeight(x);
    return x;
}
function rotateLeft(x) {
    const y = right[x], T = left[y];
    left[y] = x; right[x] = T;
    updateHeight(x); updateHeight(y);
    return y;
}

function insert(node, k) {
    if (node === 0) return newNode(k);
    if (k < key[node]) left[node] = insert(left[node], k);
    else if (k > key[node]) right[node] = insert(right[node], k);
    else return node;
    updateHeight(node);
    const bal = balance(node);
    if (bal > 1 && k < key[left[node]]) return rotateRight(node);
    if (bal < -1 && k > key[right[node]]) return rotateLeft(node);
    if (bal > 1 && k > key[left[node]]) { left[node] = rotateLeft(left[node]); return rotateRight(node); }
    if (bal < -1 && k < key[right[node]]) { right[node] = rotateRight(right[node]); return rotateLeft(node); }
    return node;
}

let root = 0;
for (let i = 0; i < n; i++) root = insert(root, ri(1000000));

const start = Date.now();
let c = 0, idx = 0;
const stack = [];
let cur = root;
while (stack.length > 0 || cur !== 0) {
    while (cur !== 0) { stack.push(cur); cur = left[cur]; }
    cur = stack.pop();
    c = (c + key[cur] * (idx % 13)) % 1000003;
    idx++;
    cur = right[cur];
}
const end = Date.now();
console.log(`Result: ${height[root]}_${c}`);
console.log(`Time: ${end - start}ms`);
