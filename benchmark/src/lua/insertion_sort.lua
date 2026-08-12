local arr = {}
for i = 1000, 1, -1 do table.insert(arr, i) end
local start = os.clock()
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
print("Result: " .. arr[1] .. "/" .. arr[#arr])

print(string.format("Time: %.0fms", (finish - start) * 1000))

