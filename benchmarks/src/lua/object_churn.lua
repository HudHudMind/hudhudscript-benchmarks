local N = 500000
local acc = 0
local start = os.clock()
for i = 1, N do
    local p = { x = i - 1, y = (i - 1) * 2, z = 0 }
    p.z = p.x + p.y
    acc = (acc + p.z) % 1000003
end
local finish = os.clock()
print("Result: " .. acc)
print(string.format("Time: %.0fms", (finish - start) * 1000))
