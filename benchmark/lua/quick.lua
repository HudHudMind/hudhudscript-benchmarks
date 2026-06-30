local start = os.clock()
local arr = {}
for i = 1000, 1, -1 do table.insert(arr, i) end
local stack = {1, #arr}
while #stack > 0 do
    local high = table.remove(stack)
    local low = table.remove(stack)
    if low < high then
        local pivot = arr[high]
        local pi = low - 1
        for j = low, high - 1 do
            if arr[j] <= pivot then
                pi = pi + 1
                arr[pi], arr[j] = arr[j], arr[pi]
            end
        end
        pi = pi + 1
        arr[pi], arr[high] = arr[high], arr[pi]
        if pi - 1 > low then
            table.insert(stack, low)
            table.insert(stack, pi - 1)
        end
        if pi + 1 < high then
            table.insert(stack, pi + 1)
            table.insert(stack, high)
        end
    end
end
local finish = os.clock()
print("First: " .. arr[1])
print("Last: " .. arr[#arr])
print(string.format("Time: %.0fms", (finish - start) * 1000))

