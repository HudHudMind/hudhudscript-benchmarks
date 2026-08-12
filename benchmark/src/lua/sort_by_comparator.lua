local N = 20000
local arr = {}
local seed = 12345
for i = 1, N do seed = (seed * 16807) % 2147483647; arr[i] = seed % 1000000 end

local function asc(a, b) return a - b end
local function desc(a, b) return b - a end

local function quicksort(a, low, high, cmp)
    if low >= high then return end
    local stack = {low, high}
    while #stack > 0 do
        local h = table.remove(stack)
        local l = table.remove(stack)
        if l >= h then goto continue end
        local pivot = a[math.floor((l + h) / 2)]
        local i2, j2 = l, h
        while i2 <= j2 do
            while cmp(a[i2], pivot) < 0 do i2 = i2 + 1 end
            while cmp(a[j2], pivot) > 0 do j2 = j2 - 1 end
            if i2 <= j2 then a[i2], a[j2] = a[j2], a[i2]; i2 = i2 + 1; j2 = j2 - 1 end
        end
        if l < j2 then stack[#stack+1] = l; stack[#stack+1] = j2 end
        if i2 < h then stack[#stack+1] = i2; stack[#stack+1] = h end
        ::continue::
    end
end

local start = os.clock()
local copy1 = {}; for i = 1, N do copy1[i] = arr[i] end; quicksort(copy1, 1, N, asc)
local copy2 = {}; for i = 1, N do copy2[i] = arr[i] end; quicksort(copy2, 1, N, desc)
local c1, c2 = 0, 0
for i = 1, N do c1 = (c1 + copy1[i] * ((i-1) % 7)) % 1000003; c2 = (c2 + copy2[i] * ((i-1) % 7)) % 1000003 end
local finish = os.clock()
print("Result: " .. c1 .. "_" .. c2)
print(string.format("Time: %.0fms", (finish - start) * 1000))
