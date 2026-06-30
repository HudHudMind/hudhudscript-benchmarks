function tak(x, y, z) {
    if (y < x) {
        return tak(
            tak(x - 1, y, z),
            tak(y - 1, z, x),
            tak(z - 1, x, y)
        );
    }
    return z;
}

let start = Date.now();
let res = 0;
for (let i = 0; i < 10; i++) {
    res = tak(18, 12, 6);
}
let end = Date.now();

console.log("Result: " + res);
console.log("Time: " + Math.floor(end - start) + "ms");
