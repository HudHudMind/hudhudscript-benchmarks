const s = "a".repeat(50000);

function is_pal(str) {
    let left = 0;
    let right = str.length - 1;
    while (left < right) {
        if (str[left] !== str[right]) {
            return false;
        }
        left++;
        right--;
    }
    return true;
}

const start = Date.now();
let ok = true;
for (let i = 0; i < 1000; i++) {
    ok = is_pal(s);
}
const end = Date.now();
console.log(`Palindrome: ${ok}`);
console.log(`Time: ${end - start}ms`);

