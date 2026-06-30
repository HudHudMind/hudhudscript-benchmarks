import time

def mandelbrot(size):
    sum_iters = 0
    for y in range(size):
        for x in range(size):
            zr = 0.0
            zi = 0.0
            cr = (2.0 * x / size) - 1.5
            ci = (2.0 * y / size) - 1.0
            escape = 0
            for i in range(50):
                tr = zr * zr - zi * zi + cr
                ti = 2.0 * zr * zi + ci
                zr = tr
                zi = ti
                if zr * zr + zi * zi > 4.0:
                    escape = 1
                    break
            sum_iters += escape
    return sum_iters

start = time.time() * 1000
res = mandelbrot(500)
end = time.time() * 1000

print(f"Sum: {res}")
print(f"Time: {end - start:.0f}ms")
