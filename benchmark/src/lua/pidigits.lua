-- Pi digits — Machin: π = 16*arctan(1/5) - 4*arctan(1/239)
-- Limb bignum base 10^9, D=600. Golden: 2668_6766940513
-- Clean buffer mgmt: each big number owns its buffer.

local BASE = 1000000000
local D = 600
local MAXL = D + 10

local function newbuf() local t = {}; for i = 1, MAXL do t[i] = 0 end; return t end

-- Big struct: {n=len, d=data}
local function big(x)
    local b = {n = 0, d = newbuf()}
    while x > 0 do b.n = b.n + 1; b.d[b.n] = x % BASE; x = math.floor(x / BASE) end
    if b.n == 0 then b.n = 1 end
    return b
end

local function big_zero()
    local b = {n = 1, d = newbuf()}; b.d[1] = 0; return b
end

local function big_copy(src)
    local b = {n = src.n, d = newbuf()}
    for i = 1, src.n do b.d[i] = src.d[i] end
    return b
end

-- Swap contents of a and b in-place (just swap data tables and lengths)
local function swap(a, b)
    a.n, b.n = b.n, a.n
    a.d, b.d = b.d, a.d
end

local function cmp(a, b)
    if a.n ~= b.n then return a.n < b.n end
    for i = a.n, 1, -1 do if a.d[i] ~= b.d[i] then return a.d[i] < b.d[i] end end
    return false
end

-- dst = a + b (dst must be separate buffer)
local function add_into(a, b, dst)
    local c, n = 0, math.max(a.n, b.n)
    for i = 1, n do
        local v = (a.d[i] or 0) + (b.d[i] or 0) + c
        if v >= BASE then v = v - BASE; c = 1 else c = 0 end
        dst.d[i] = v
    end
    if c > 0 then n = n + 1; dst.d[n] = c end
    dst.n = n
end

-- dst = a - b (a >= b), dst must be separate
local function sub_into(a, b, dst)
    local bo, n = 0, a.n
    for i = 1, a.n do
        local v = a.d[i] - (b.d[i] or 0) - bo
        if v < 0 then v = v + BASE; bo = 1 else bo = 0 end
        dst.d[i] = v
    end
    while n > 1 and dst.d[n] == 0 do n = n - 1 end
    dst.n = n
end

-- dst = a * s (s small), dst must be separate
local function muls_into(a, s, dst)
    local c, n = 0, a.n
    for i = 1, a.n do
        local v = a.d[i] * s + c
        c = math.floor(v / BASE)
        dst.d[i] = v - c * BASE
    end
    while c > 0 do n = n + 1; dst.d[n] = c % BASE; c = math.floor(c / BASE) end
    dst.n = n
end

-- (q, rem) = a // s (s small). q written to dst, returns remainder.
local function divs_into(a, s, dst)
    local rem = 0
    local tmp = {}
    local qn = 0
    for i = a.n, 1, -1 do
        rem = rem * BASE + a.d[i]
        local qd = math.floor(rem / s)
        rem = rem - qd * s
        qn = qn + 1; tmp[qn] = qd
    end
    for i = 1, qn do dst.d[i] = tmp[qn - i + 1] end
    local n = qn
    while n > 1 and dst.d[n] == 0 do n = n - 1 end
    dst.n = n
    return rem
end

-- Convert to decimal string
local function to_str(a)
    if a.n == 1 and a.d[1] == 0 then return "0" end
    local parts = {}
    local tmp = big_copy(a)
    while tmp.n > 1 or tmp.d[1] > 0 do
        local rem = divs_into(tmp, BASE, tmp)
        parts[#parts + 1] = string.format("%09d", rem)
    end
    local s = ""
    for i = #parts, 1, -1 do s = s .. parts[i] end
    s = s:gsub("^0+", "") or ""
    return s == "" and "0" or s
end

local function lpad(s, w)
    while #s < w do s = "0" .. s end
    return s
end

-- ── arctan(1/x) to 'digits' decimal places ─────────────────────
-- Fixed-point: result * 10^(digits+GUARD)
local function arctan_inv(x, digits)
    local GUARD = 5
    
    -- result = 0
    local res = big_zero()
    
    -- term = 10^(digits+GUARD) / x
    local term = big(10)
    for i = 2, digits + GUARD do
        local t2 = big(0)
        muls_into(term, 10, t2)
        swap(term, t2)
    end
    local t2 = big(0)
    divs_into(term, x, t2)
    swap(term, t2)
    
    local x2 = x * x
    local sign = 1
    local max_iter = (digits + GUARD) * 3 + 20
    
    for k = 0, max_iter do
        local divisor = 2 * k + 1
        
        -- term_k = term / divisor
        local tdiv = big(0)
        divs_into(term, divisor, tdiv)
        
        -- Check if term_k is zero
        local is_zero = true
        for i = 1, tdiv.n do
            if tdiv.d[i] ~= 0 then is_zero = false; break end
        end
        if is_zero then break end
        
        if sign > 0 then
            local tmp = big(0)
            add_into(res, tdiv, tmp)
            swap(res, tmp)
        else
            local tmp = big(0)
            sub_into(res, tdiv, tmp)
            swap(res, tmp)
        end
        
        sign = -sign
        
        -- term = term / x²  (for next iteration)
        local next_term = big(0)
        divs_into(term, x2, next_term)
        swap(term, next_term)
    end
    
    return res
end

-- ── Main ───────────────────────────────────────────────────────
local start = os.clock()

local a5 = arctan_inv(5, D + 5)
local a239 = arctan_inv(239, D + 5)

-- pi = 16*a5 - 4*a239
local tmp1, tmp2, tmp3 = big(0), big(0), big(0)
muls_into(a5, 16, tmp1)
muls_into(a239, 4, tmp2)
sub_into(tmp1, tmp2, tmp3)

local pi_str = to_str(tmp3)
pi_str = lpad(pi_str, D + 10)
pi_str = pi_str:sub(1, D)

local ds = 0
for i = 1, D do ds = ds + tonumber(pi_str:sub(i, i)) end
local lt = pi_str:sub(D - 9)

local finish = os.clock()
print("Result: " .. ds .. "_" .. lt)
print(string.format("Time: %.0fms", (finish - start) * 1000))
