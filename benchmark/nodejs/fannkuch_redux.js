function fannkuch(n) {
    let p = new Int32Array(n);
    let q = new Int32Array(n);
    let s = new Int32Array(n);
    let sign = 1;
    let maxflips = 0;
    let sumflips = 0;

    for (let i = 0; i < n; i++) {
        p[i] = i;
        q[i] = i;
        s[i] = i;
    }

    while (true) {
        let q1 = p[0];
        if (q1 !== 0) {
            for (let i = 1; i < n; i++) q[i] = p[i];
            let flips = 1;
            while (true) {
                let qq = q[q1];
                if (qq === 0) break;
                q[q1] = q1;
                if (q1 >= 3) {
                    let i = 1, j = q1 - 1;
                    while (i < j) {
                        let t = q[i];
                        q[i] = q[j];
                        q[j] = t;
                        i++;
                        j--;
                    }
                }
                q1 = qq;
                flips++;
            }
            if (flips > maxflips) maxflips = flips;
            sumflips += sign * flips;
        }

        if (sign === 1) {
            let t = p[1];
            p[1] = p[0];
            p[0] = t;
            sign = -1;
        } else {
            let t = p[1];
            p[1] = p[2];
            p[2] = t;
            sign = 1;
            let k = 2;
            for (; k < n; k++) {
                s[k]--;
                if (s[k] !== 0) break;
                s[k] = k;
                let t0 = p[0];
                for (let m = 0; m <= k; m++) {
                    p[m] = m < k ? p[m + 1] : t0;
                }
            }
            if (k === n) break;
        }
    }
    return `${sumflips}_${maxflips}`;
}

const start = Date.now();
const res = fannkuch(9);
const end = Date.now();

console.log(`Result: ${res}`);
console.log(`Time: ${end - start}ms`);
