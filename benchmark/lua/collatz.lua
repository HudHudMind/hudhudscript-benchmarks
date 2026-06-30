local start = os.clock()
local max_steps = 0
local max_n = 0
for n = 1, 10000 do
    local steps = 0
    local current = n
    while current ~= 1 do
        if current % 2 == 0 then
            current = current // 2
        else
            current = current * 3 + 1
        end
        steps = steps + 1
    end
    if steps > max_steps then
        max_steps = steps
        max_n = n
    end
end
local finish = os.clock()
print("Max steps: " .. max_steps .. " at n=" .. max_n)
print(string.format("Time: %.0fms", (finish - start) * 1000))

