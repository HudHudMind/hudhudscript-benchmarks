local base = {}
for i = 1, 1000 do base[i] = i - 1 end
local function my_map(arr, fn)
    local r = {}
    for i = 1, #arr do r[i] = fn(arr[i]) end
    return r
end
local function my_filter(arr, fn)
    local r = {}
    for i = 1, #arr do if fn(arr[i]) then r[#r+1] = arr[i] end end
    return r
end
local function my_reduce(arr, fn, init)
    local a = init
    for i = 1, #arr do a = fn(a, arr[i]) end
    return a
end

local R = 2000
local acc = 0
local start = os.clock()
for r = 1, R do
    local d = my_map(base, function(x) return x * 2 + 1 end)
    local f = my_filter(d, function(x) return x % 3 ~= 0 end)
    local s = my_reduce(f, function(a, x) return a + x end, 0)
    acc = (acc + s + #f) % 1000003
end
local finish = os.clock()
print("Result: " .. acc)
print(string.format("Time: %.0fms", (finish - start) * 1000))
