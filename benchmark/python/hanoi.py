import time

def hanoi(n):
    if n == 1:
        return 1
    return hanoi(n - 1) + 1 + hanoi(n - 1)

start = time.time() * 1000
moves = hanoi(20)
end = time.time() * 1000
print(f"Moves: {moves}")
print(f"Time: {end - start:.0f}ms")

