local function eval_A(i, j)
    return 1.0 / (((i + j) * (i + j + 1.0) / 2.0) + i + 1.0)
end

local function eval_A_times_u(u, v, n)
    for i = 0, n - 1 do
        v[i] = 0.0
        for j = 0, n - 1 do
            v[i] = v[i] + eval_A(i, j) * u[j]
        end
    end
end

local function eval_At_times_u(u, v, n)
    for i = 0, n - 1 do
        v[i] = 0.0
        for j = 0, n - 1 do
            v[i] = v[i] + eval_A(j, i) * u[j]
        end
    end
end

local function eval_AtA_times_u(u, v, w, n)
    eval_A_times_u(u, w, n)
    eval_At_times_u(w, v, n)
end

local start = os.clock() * 1000
local n = 150
local u, v, w = {}, {}, {}
for i = 0, n - 1 do
    u[i] = 1.0
    v[i] = 0.0
    w[i] = 0.0
end

for i = 1, 10 do
    eval_AtA_times_u(u, v, w, n)
    eval_AtA_times_u(v, u, w, n)
end

local vBv = 0.0
local vv = 0.0
for i = 0, n - 1 do
    vBv = vBv + u[i] * v[i]
    vv = vv + v[i] * v[i]
end

local res = math.sqrt(vBv / vv)
local end_time = os.clock() * 1000

print(string.format("Result: %.9f", res))
print("Time: " .. math.floor(end_time - start) .. "ms")
