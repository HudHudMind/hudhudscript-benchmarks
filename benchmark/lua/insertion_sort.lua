local start = os.clock()
local arr = {}
for i = 1000, 1, -1 do table.insert(arr, i) end
for j = 2, #arr do
    local key = arr[j]
    local k = j - 1
    while k >= 1 and arr[k] > key do
        arr[k + 1] = arr[k]
        k = k - 1
    end
    arr[k + 1] = key
end
local finish = os.clock()
print("First: " .. arr[1])
print("Last: " .. arr[#arr])
print(string.format("Time: %.0fms", (finish - start) * 1000))

