local n = 100
local adj = {}
for i = 0, n - 1 do
    adj[i] = {}
    for j = 0, n - 1 do
        adj[i][j] = 0
    end
end
for i = 0, n - 1 do
    for j = 0, n - 1 do
        if (i * 3 + j * 7) % 11 == 0 then
            if i ~= j then
                adj[i][j] = 1
            end
        end
    end
end
local start = os.clock()
local visited = {}
for i = 0, n - 1 do
    visited[i] = false
end
local stack = {0}
local count = 0
while true do
    if #stack == 0 then
        break
    end
    local node = table.remove(stack)
    if not visited[node] then
        visited[node] = true
        count = count + 1
        for neighbor = n - 1, 0, -1 do
            if adj[node][neighbor] == 1 then
                if not visited[neighbor] then
                    table.insert(stack, neighbor)
                end
            end
        end
    end
end
local finish = os.clock()
print("Visited: " .. count)
print(string.format("Time: %.0fms", (finish - start) * 1000))

