const start = Date.now();
const arr = [];
for (let i = 1000; i > 0; i--) arr.push(i);
const n = arr.length;
for (let width = 1; width < n; width *= 2) {
    for (let left = 0; left < n; left += 2 * width) {
        const mid = left + width - 1;
        if (mid < n - 1) {
            let right = left + 2 * width - 1;
            if (right >= n) right = n - 1;
            const n1 = mid - left + 1;
            const n2 = right - mid;
            const L = [];
            const R = [];
            for (let k = 0; k < n1; k++) L.push(arr[left + k]);
            for (let k = 0; k < n2; k++) R.push(arr[mid + 1 + k]);
            let i = 0, j = 0, m = left;
            while (i < n1 && j < n2) {
                if (L[i] <= R[j]) {
                    arr[m] = L[i];
                    i++;
                } else {
                    arr[m] = R[j];
                    j++;
                }
                m++;
            }
            while (i < n1) { arr[m] = L[i]; i++; m++; }
            while (j < n2) { arr[m] = R[j]; j++; m++; }
        }
    }
}
const end = Date.now();
console.log(`First: ${arr[0]}`);
console.log(`Last: ${arr[arr.length - 1]}`);
console.log(`Time: ${end - start}ms`);

