import time
n = 100
adj = [[0] * n for _ in range(n)]
for i in range(n):
    for j in range(n):
        if (i * 3 + j * 7) % 11 == 0 and i != j:
            adj[i][j] = 1
start = time.time() * 1000
visited = [False] * n
queue = [0]
head = 0
count = 0
while head < len(queue):
    node = queue[head]
    head += 1
    if not visited[node]:
        visited[node] = True
        count += 1
        for neighbor in range(n):
            if adj[node][neighbor] == 1 and not visited[neighbor]:
                queue.append(neighbor)
end = time.time() * 1000
print(f"Visited: {count}")
print(f"Time: {end - start:.0f}ms")

