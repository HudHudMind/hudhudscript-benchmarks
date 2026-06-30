let text = "";
for (let i = 0; i < 1000; i = i + 1) {
    text = text + "abcdefghij";
}
const pattern = "defg";
const text_len = text.length;
const pat_len = pattern.length;
let count = 0;
const start = Date.now();
for (let t = 0; t <= text_len - pat_len; t = t + 1) {
    let match = true;
    for (let p = 0; p < pat_len; p = p + 1) {
        if (text[t + p] !== pattern[p]) {
            match = false;
            break;
        }
    }
    if (match) {
        count = count + 1;
    }
}
const end = Date.now();
console.log(`Count: ${count}`);
console.log(`Time: ${end - start}ms`);
