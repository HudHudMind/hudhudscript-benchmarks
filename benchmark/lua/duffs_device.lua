function duffs_device(count)
    local a, b = {}, {}
    for i = 1, count do
        a[i] = 0
        b[i] = 1
    end
    
    local n = math.floor(count / 8)
    local rem = count % 8
    local i = 1
    
    while rem > 0 do
        a[i] = b[i]
        i = i + 1
        rem = rem - 1
    end
    
    while n > 0 do
        a[i] = b[i]; i = i + 1
        a[i] = b[i]; i = i + 1
        a[i] = b[i]; i = i + 1
        a[i] = b[i]; i = i + 1
        a[i] = b[i]; i = i + 1
        a[i] = b[i]; i = i + 1
        a[i] = b[i]; i = i + 1
        a[i] = b[i]; i = i + 1
        n = n - 1
    end
    return a[count]
end

local start = os.clock() * 1000
local res = 0
for k = 1, 100 do
    res = duffs_device(100000)
end
local end_time = os.clock() * 1000

print("Result: " .. res)
print("Time: " .. math.floor(end_time - start) .. "ms")
