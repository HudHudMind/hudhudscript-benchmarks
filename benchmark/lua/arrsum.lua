local arr = {}
for i = 1, 10000 do
    arr[i] = i - 1
end
local sum = 0
local start = os.clock()
for i = 1, 10000 do
    sum = sum + arr[i]
end
local finish = os.clock()
print("Sum: " .. sum)
print(string.format("Time: %.0fms", (finish - start) * 1000))
