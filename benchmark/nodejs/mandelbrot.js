function mandelbrot(size) {
    let sumIters = 0;
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
            let zr = 0.0, zi = 0.0;
            let cr = (2.0 * x / size) - 1.5;
            let ci = (2.0 * y / size) - 1.0;
            let escape = 0;
            for (let i = 0; i < 50; i++) {
                let tr = zr * zr - zi * zi + cr;
                let ti = 2.0 * zr * zi + ci;
                zr = tr;
                zi = ti;
                if (zr * zr + zi * zi > 4.0) {
                    escape = 1;
                    break;
                }
            }
            sumIters += escape;
        }
    }
    return sumIters;
}

let start = Date.now();
let res = mandelbrot(500);
let end = Date.now();

console.log("Sum: " + res);
console.log("Time: " + Math.floor(end - start) + "ms");
