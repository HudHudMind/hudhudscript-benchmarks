local s = string.rep("a", 50000)

local function is_pal(str)
    local left = 1
    local right = #str
    while left < right do
        if string.sub(str, left, left) ~= string.sub(str, right, right) then
            return false
        end
        left = left + 1
        right = right - 1
    end
    return true
end

local start = os.clock()
local ok = true
for i = 1, 1000 do
    ok = is_pal(s)
end
local finish = os.clock()
print("Palindrome: " .. tostring(ok))
print(string.format("Time: %.0fms", (finish - start) * 1000))

