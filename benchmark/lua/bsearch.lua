local arr = {}
for i = 1, 100000 do
    arr[i] = (i - 1) * 2
end
local start = os.clock()
local found = 0
for j = 1, 10000 do
    local target = (j - 1) * 20
    local left = 1
    local right = 100000
    while left <= right do
        local mid = math.floor((left + right) / 2)
        if arr[mid] == target then
            found = found + 1
            break
        end
        if arr[mid] < target then
            left = mid + 1
        else
            right = mid - 1
        end
    end
end
local finish = os.clock()
print("Found: " .. found)
print(string.format("Time: %.0fms", (finish - start) * 1000))

