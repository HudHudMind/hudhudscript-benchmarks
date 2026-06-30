import time

text = ""
for i in range(1000):
    text = text + "abcdefghij"
pattern = "defg"
text_len = len(text)
pat_len = len(pattern)
count = 0
start = time.time() * 1000
for t in range(text_len - pat_len + 1):
    match = True
    for p in range(pat_len):
        if text[t + p] != pattern[p]:
            match = False
            break
    if match:
        count = count + 1
end = time.time() * 1000
print(f"Count: {count}")
print(f"Time: {end - start:.0f}ms")
