function bottomUpTree(depth) {
    if (depth > 0) {
        return [bottomUpTree(depth - 1), bottomUpTree(depth - 1)];
    } else {
        return [];
    }
}

function itemCheck(tree) {
    if (tree.length > 0) {
        return 1 + itemCheck(tree[0]) + itemCheck(tree[1]);
    } else {
        return 1;
    }
}

let start = Date.now();
let maxDepth = 12;
let minDepth = 4;
let stretchDepth = maxDepth + 1;

let stretchTree = bottomUpTree(stretchDepth);
let check = itemCheck(stretchTree);

let longLivedTree = bottomUpTree(maxDepth);

for (let depth = minDepth; depth <= maxDepth; depth += 2) {
    let iterations = 1 << (maxDepth - depth + minDepth);
    let checkSum = 0;
    for (let i = 0; i < iterations; i++) {
        checkSum += itemCheck(bottomUpTree(depth));
    }
}

let longLivedCheck = itemCheck(longLivedTree);
let end = Date.now();

console.log("Result: " + check + "_" + longLivedCheck);
console.log("Time: " + Math.floor(end - start) + "ms");
