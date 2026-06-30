import time

s = "a" * 50000

def is_pal(s):
    left = 0
    right = len(s) - 1
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    return True

start = time.time() * 1000
ok = True
for i in range(1000):
    ok = is_pal(s)
end = time.time() * 1000
print(f"Palindrome: {str(ok).lower()}")
print(f"Time: {end - start:.0f}ms")

