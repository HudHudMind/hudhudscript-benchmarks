local inside = 0
local total = 500000
local seed = 12345
local function next_random()
    seed = (seed * 16807) % 2147483647
    return seed / 2147483647.0
end
local start = os.clock()
for i = 1, total do
    local x = next_random()
    local y = next_random()
    if x * x + y * y <= 1.0 then
        inside = inside + 1
    end
end
local finish = os.clock()
local pi = 4.0 * inside / total
print("Pi: " .. pi)
print(string.format("Time: %.0fms", (finish - start) * 1000))
