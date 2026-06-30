const start = Date.now();
const board = new Array(8).fill(0);
let count = 0;
let row = 0;
let col = 0;

while (true) {
    if (row < 0) {
        break;
    }
    if (row === 8) {
        count++;
        row--;
        if (row >= 0) {
            col = board[row] + 1;
        }
    } else {
        if (col >= 8) {
            board[row] = 0;
            row--;
            if (row >= 0) {
                col = board[row] + 1;
            }
        } else {
            let safe = true;
            for (let i = 0; i < row; i++) {
                if (board[i] === col) {
                    safe = false;
                    i = row;
                } else {
                    let diff1 = board[i] - col;
                    if (diff1 < 0) { diff1 = -diff1; }
                    let diff2 = i - row;
                    if (diff2 < 0) { diff2 = -diff2; }
                    if (diff1 === diff2) {
                        safe = false;
                        i = row;
                    }
                }
            }
            if (safe) {
                board[row] = col;
                row++;
                col = 0;
            } else {
                col++;
            }
        }
    }
}
const end = Date.now();
console.log(`Solutions: ${count}`);
console.log(`Time: ${end - start}ms`);

