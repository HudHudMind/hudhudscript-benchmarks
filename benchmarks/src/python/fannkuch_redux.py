def fannkuch(n):
    p = list(range(n))
    q = list(range(n))
    s = list(range(n))
    sign = 1
    maxflips = 0
    sumflips = 0

    while True:
        q1 = p[0]
        if q1 != 0:
            for i in range(1, n):
                q[i] = p[i]
            flips = 1
            while True:
                qq = q[q1]
                if qq == 0:
                    break
                q[q1] = q1
                if q1 >= 3:
                    i, j = 1, q1 - 1
                    while i < j:
                        q[i], q[j] = q[j], q[i]
                        i += 1
                        j -= 1
                q1 = qq
                flips += 1
            if flips > maxflips:
                maxflips = flips
            sumflips += sign * flips
            
        if sign == 1:
            p[1], p[0] = p[0], p[1]
            sign = -1
        else:
            p[1], p[2] = p[2], p[1]
            sign = 1
            for i in range(2, n):
                s[i] -= 1
                if s[i] != 0:
                    break
                s[i] = i
                t = p[0]
                for j in range(i + 1):
                    p[j] = p[j + 1] if j < i else t
            else:
                break
    return sumflips, maxflips

import time
start = time.time()
sf, mf = fannkuch(9)
end = time.time()
print(f"Result: {sf}_{mf}")
print(f"Time: {int((end - start)*1000)}ms")
