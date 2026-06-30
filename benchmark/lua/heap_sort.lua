local start = os.clock()
local arr = {}
for i = 1000, 1, -1 do table.insert(arr, i) end
local function heapify(n, idx)
    local largest = idx
    local left = 2 * idx + 1
    local right = 2 * idx + 2
    if left < n and arr[left + 1] > arr[largest + 1] then largest = left end
    if right < n and arr[right + 1] > arr[largest + 1] then largest = right end
    if largest ~= idx then
        arr[idx + 1], arr[largest + 1] = arr[largest + 1], arr[idx + 1]
        heapify(n, largest)
    end
end
local n = #arr
for j = math.floor(n / 2) - 1, 0, -1 do heapify(n, j) end
for k = n - 1, 1, -1 do
    arr[1], arr[k + 1] = arr[k + 1], arr[1]
    heapify(k, 0)
end
local finish = os.clock()
print("First: " .. arr[1])
print("Last: " .. arr[#arr])
print(string.format("Time: %.0fms", (finish - start) * 1000))

