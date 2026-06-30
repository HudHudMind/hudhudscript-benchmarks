local start = os.clock()
local arr = {}
for i = 1000, 1, -1 do table.insert(arr, i) end
local n = #arr
local width = 1
while width < n do
    local left = 1
    while left <= n do
        local mid = left + width - 1
        if mid < n then
            local right = left + 2 * width - 1
            if right > n then right = n end
            local n1 = mid - left + 1
            local n2 = right - mid
            local L = {}
            local R = {}
            for k = 1, n1 do L[k] = arr[left + k - 1] end
            for k = 1, n2 do R[k] = arr[mid + k] end
            local i, j = 1, 1
            local m = left
            while i <= n1 and j <= n2 do
                if L[i] <= R[j] then
                    arr[m] = L[i]
                    i = i + 1
                else
                    arr[m] = R[j]
                    j = j + 1
                end
                m = m + 1
            end
            while i <= n1 do
                arr[m] = L[i]
                i = i + 1
                m = m + 1
            end
            while j <= n2 do
                arr[m] = R[j]
                j = j + 1
                m = m + 1
            end
        end
        left = left + 2 * width
    end
    width = width * 2
end
local finish = os.clock()
print("First: " .. arr[1])
print("Last: " .. arr[n])
print(string.format("Time: %.0fms", (finish - start) * 1000))

