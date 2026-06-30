local start = os.clock()
local arr = {}
for i = 1, 1000000 do arr[i] = i end
local s = 0
for i = 1, 1000000 do s = s + arr[i] end
local mean = s / #arr
local sq_diff = 0
for i = 1, #arr do
    local diff = arr[i] - mean
    sq_diff = sq_diff + diff * diff
end
local variance = sq_diff / #arr
local finish = os.clock()
print("Mean: " .. mean)
print("Variance: " .. variance)
print(string.format("Time: %.0fms", (finish - start) * 1000))

