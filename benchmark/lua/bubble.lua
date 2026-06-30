local n = 500
local arr = {}
for i = n, 1, -1 do
    table.insert(arr, i)
end
local start = os.clock()
for k = 1, n do
    for j = 1, n - 1 do
        if arr[j] > arr[j + 1] then
            local temp = arr[j]
            arr[j] = arr[j + 1]
            arr[j + 1] = temp
        end
    end
end
local finish = os.clock()
print("First: " .. arr[1])
print("Last: " .. arr[n])
print(string.format("Time: %.0fms", (finish - start) * 1000))

