local function make_counter(start)
    local c = start
    return function()
        c = c + 1
        return c
    end
end

local N = 150000
local acc = 0
local start = os.clock()
for i = 1, N do
    local ctr = make_counter((i - 1) % 1000)
    acc = (acc + ctr() + ctr() + ctr()) % 1000003
end
local finish = os.clock()
print("Result: " .. acc)
print(string.format("Time: %.0fms", (finish - start) * 1000))
