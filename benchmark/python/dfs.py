import time

n = 100
adj = []
for i in range(n):
    row = []
    for j in range(n):
        row.append(0)
    adj.append(row)
for i in range(n):
    for j in range(n):
        if (i * 3 + j * 7) % 11 == 0:
            if i != j:
                adj[i][j] = 1
start = time.time() * 1000
visited = []
for i in range(n):
    visited.append(False)
stack = [0]
count = 0
while True:
    if len(stack) == 0:
        break
    node = stack.pop()
    if not visited[node]:
        visited[node] = True
        count = count + 1
        for neighbor in range(n - 1, -1, -1):
            if adj[node][neighbor] == 1:
                if not visited[neighbor]:
                    stack.append(neighbor)
end = time.time() * 1000
print(f"Visited: {count}")
print(f"Time: {end - start:.0f}ms")

