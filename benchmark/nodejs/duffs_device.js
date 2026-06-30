function duffsDevice(count) {
    let a = new Array(count).fill(0);
    let b = new Array(count).fill(1);
    
    let n = Math.floor(count / 8);
    let rem = count % 8;
    let i = 0;
    
    while (rem > 0) {
        a[i] = b[i];
        i++;
        rem--;
    }
    
    while (n > 0) {
        a[i] = b[i]; i++;
        a[i] = b[i]; i++;
        a[i] = b[i]; i++;
        a[i] = b[i]; i++;
        a[i] = b[i]; i++;
        a[i] = b[i]; i++;
        a[i] = b[i]; i++;
        a[i] = b[i]; i++;
        n--;
    }
    return a[count - 1];
}

let start = Date.now();
let res = 0;
for (let k = 0; k < 100; k++) {
    res = duffsDevice(100000);
}
let end = Date.now();

console.log("Result: " + res);
console.log("Time: " + Math.floor(end - start) + "ms");
