local sum = 0
local start = os.clock()
for i = 1, 1000000 do
    sum = sum + i * i
end
local finish = os.clock()
print("Sum: " .. sum)
print(string.format("Time: %.0fms", (finish - start) * 1000))
