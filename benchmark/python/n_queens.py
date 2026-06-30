import time

board = [0] * 8
start = time.time() * 1000
count = 0
row = 0
col = 0

while True:
    if row < 0:
        break
    if row == 8:
        count += 1
        row -= 1
        if row >= 0:
            col = board[row] + 1
    else:
        if col >= 8:
            board[row] = 0
            row -= 1
            if row >= 0:
                col = board[row] + 1
        else:
            safe = True
            i = 0
            while i < row:
                if board[i] == col:
                    safe = False
                    i = row
                else:
                    diff1 = board[i] - col
                    if diff1 < 0:
                        diff1 = -diff1
                    diff2 = i - row
                    if diff2 < 0:
                        diff2 = -diff2
                    if diff1 == diff2:
                        safe = False
                        i = row
                    else:
                        i += 1
            if safe:
                board[row] = col
                row += 1
                col = 0
            else:
                col += 1

end = time.time() * 1000
print(f"Solutions: {count}")
print(f"Time: {end - start:.0f}ms")

