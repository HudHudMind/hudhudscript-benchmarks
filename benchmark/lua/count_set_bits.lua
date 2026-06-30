local start = os.clock()
local total = 0
for n = 1, 100000 do
    local x = n + 0.0
    while x > 0.5 do
        if x % 2 >= 1 then
            total = total + 1
        end
        x = x / 2
    end
end
local finish = os.clock()
print("Total: " .. total)
print(string.format("Time: %.0fms", (finish - start) * 1000))

