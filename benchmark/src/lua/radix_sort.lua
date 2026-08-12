local n = 200000
local seed = 12345
local function ri(m)
    seed = (seed * 16807) % 2147483647
    return seed % m
end

local arr = {}
for i = 1, n do arr[i] = ri(1000000) end

local start = os.clock()

local buckets = {}
for i = 0, 9 do buckets[i] = 0 end
local output = {}

for p = 0, 5 do
    for i = 0, 9 do buckets[i] = 0 end
    local div = 10 ^ p
    for i = 1, n do
        local d = math.floor(arr[i] / div) % 10
        buckets[d] = buckets[d] + 1
    end
    for i = 1, 9 do
        buckets[i] = buckets[i] + buckets[i - 1]
    end
    for i = n, 1, -1 do
        local d = math.floor(arr[i] / div) % 10
        buckets[d] = buckets[d] - 1
        output[buckets[d] + 1] = arr[i]
    end
    arr, output = output, arr
end

local c = 0
for i = 1, n do
    c = (c + arr[i] * ((i - 1) % 7)) % 1000003
end

local finish = os.clock()
print("Result: " .. arr[1] .. "/" .. arr[n] .. "_" .. c)
print(string.format("Time: %.0fms", (finish - start) * 1000))
