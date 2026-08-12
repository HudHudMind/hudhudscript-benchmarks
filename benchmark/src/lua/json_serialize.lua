local seed = 12345
local function ri(m) seed = (seed * 16807) % 2147483647; return seed % m end
local function gen(depth)
    if depth == 7 then return ri(100000) end
    local node = {}
    node.a = ri(4) == 0 and ri(100000) or gen(depth + 1)
    node.b = ri(4) == 0 and ri(100000) or gen(depth + 1)
    node.c = ri(4) == 0 and ri(100000) or gen(depth + 1)
    node.s = "x" .. tostring(ri(1000))
    return node
end
local function countNodes(node)
    if type(node) == "number" or type(node) == "string" then return 0 end
    return 1 + countNodes(node.a) + countNodes(node.b) + countNodes(node.c)
end
local function serialize(node)
    if type(node) == "number" then return tostring(node) end
    local parts = {'{"a":', serialize(node.a), ',"b":', serialize(node.b), ',"c":', serialize(node.c), ',"s":"', node.s, '"}'}
    return table.concat(parts)
end
local tree = gen(0)
local nc = countNodes(tree)
local start = os.clock()
local total = 0
for _ = 1, 50 do total = total + #serialize(tree) end
local finish = os.clock()
print("Result: " .. (total % 1000003) .. "_" .. nc)
print(string.format("Time: %.0fms", (finish - start) * 1000))
