let seed = 12345;
function ri(m) { seed = (seed * 16807) % 2147483647; return seed % m; }
function gen(depth) {
    if (depth === 7) return ri(100000);
    const node = {};
    node.a = ri(4) === 0 ? ri(100000) : gen(depth + 1);
    node.b = ri(4) === 0 ? ri(100000) : gen(depth + 1);
    node.c = ri(4) === 0 ? ri(100000) : gen(depth + 1);
    node.s = "x" + String(ri(1000));
    return node;
}
function countNodes(node) {
    if (typeof node === 'number' || typeof node === 'string') return 0;
    return 1 + countNodes(node.a) + countNodes(node.b) + countNodes(node.c);
}
function serialize(node) {
    if (typeof node === 'number') return String(node);
    const parts = ['{"a":', serialize(node.a), ',"b":', serialize(node.b), ',"c":', serialize(node.c), ',"s":"', node.s, '"}'];
    return parts.join("");
}
const tree = gen(0);
const nc = countNodes(tree);
const start = Date.now();
let total = 0;
for (let i = 0; i < 50; i++) total += serialize(tree).length;
const end = Date.now();
console.log(`Result: ${total % 1000003}_${nc}`);
console.log(`Time: ${end - start}ms`);
