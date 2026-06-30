local n = 100
local adj = {}
for i = 0, n - 1 do
    adj[i] = {}
    for j = 0, n - 1 do adj[i][j] = 0 end
end
for i = 0, n - 1 do
    for j = 0, n - 1 do
        if (i * 3 + j * 7) % 11 == 0 and i ~= j then
            adj[i][j] = 1
        end
    end
end
local start = os.clock()
local visited = {}
for i = 0, n - 1 do visited[i] = false end
local queue = {0}
local head = 1
local count = 0
while head <= #queue do
    local node = queue[head]
    head = head + 1
    if not visited[node] then
        visited[node] = true
        count = count + 1
        for neighbor = 0, n - 1 do
            if adj[node][neighbor] == 1 and not visited[neighbor] then
                table.insert(queue, neighbor)
            end
        end
    end
end
local finish = os.clock()
print("Visited: " .. count)
print(string.format("Time: %.0fms", (finish - start) * 1000))

