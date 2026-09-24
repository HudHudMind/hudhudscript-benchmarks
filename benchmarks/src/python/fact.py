import time
import sys
sys.set_int_max_str_digits(50000)
start = time.time() * 1000
result = 1
for i in range(2, 10001):
    result *= i
end = time.time() * 1000
print(f"Result: {result}")
print(f"Time: {end - start:.0f}ms")

