local function ack(m, n)
    if m == 0 then
        return n + 1
    end
    if n == 0 then
        return ack(m - 1, 1)
    end
    return ack(m - 1, ack(m, n - 1))
end

local start = os.clock()
local result = ack(3, 6)
local finish = os.clock()
print("Result: " .. result)
print(string.format("Time: %.0fms", (finish - start) * 1000))

