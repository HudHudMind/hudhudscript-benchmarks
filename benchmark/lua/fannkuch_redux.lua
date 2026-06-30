local function fannkuch(n)
    local p, q, s = {}, {}, {}
    local sign = 1
    local maxflips = 0
    local sumflips = 0

    for i = 1, n do
        p[i] = i
        q[i] = i
        s[i] = i
    end

    while true do
        local q1 = p[1]
        if q1 ~= 1 then
            for i = 2, n do q[i] = p[i] end
            local flips = 1
            while true do
                local qq = q[q1]
                if qq == 1 then break end
                q[q1] = q1
                if q1 >= 4 then
                    local i, j = 2, q1 - 1
                    while i < j do
                        q[i], q[j] = q[j], q[i]
                        i = i + 1
                        j = j - 1
                    end
                end
                q1 = qq
                flips = flips + 1
            end
            if flips > maxflips then maxflips = flips end
            sumflips = sumflips + sign * flips
        end
        
        if sign == 1 then
            p[2], p[1] = p[1], p[2]
            sign = -1
        else
            p[2], p[3] = p[3], p[2]
            sign = 1
            local k = 3
            while k <= n do
                s[k] = s[k] - 1
                if s[k] ~= 1 then break end
                s[k] = k
                local t = p[1]
                for m = 1, k do
                    if m < k then
                        p[m] = p[m + 1]
                    else
                        p[m] = t
                    end
                end
                k = k + 1
            end
            if k > n then break end
        end
    end
    return sumflips, maxflips
end

local start = os.clock() * 1000
local sf, mf = fannkuch(9)
local end_time = os.clock() * 1000

print("Result: " .. sf .. "_" .. mf)
print("Time: " .. math.floor(end_time - start) .. "ms")
