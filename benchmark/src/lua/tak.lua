function tak(x, y, z)
    if y < x then
        return tak(
            tak(x - 1, y, z),
            tak(y - 1, z, x),
            tak(z - 1, x, y)
        )
    end
    return z
end

local start = os.clock() * 1000
local res = 0
for i = 1, 10 do
    res = tak(18, 12, 6)
end
local end_time = os.clock() * 1000

print("Result: " .. res)
print("Time: " .. math.floor(end_time - start) .. "ms")
