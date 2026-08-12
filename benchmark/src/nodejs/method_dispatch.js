class Shape { score() { return 0; } }
class A extends Shape { score() { return this.v * 2; } }
class B extends Shape { score() { return this.v * 3 + 1; } }
class C extends Shape { score() { return this.v * 5 - 2; } }

const shapes = [];
for (let i = 0; i < 3000; i++) {
    const r = i % 3;
    let obj;
    if (r === 0) obj = new A();
    else if (r === 1) obj = new B();
    else obj = new C();
    obj.v = i % 97;
    shapes.push(obj);
}

const P = 300;
let acc = 0;
const start = Date.now();
for (let round = 0; round < P; round++) {
    for (let j = 0; j < 3000; j++) {
        acc = (acc + shapes[j].score()) % 1000003;
    }
}
const end = Date.now();
console.log("Result: " + acc);
console.log("Time: " + Math.floor(end - start) + "ms");
