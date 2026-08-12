local n = 20000
local seed = 12345
local function ri(m) seed = (seed * 16807) % 2147483647; return seed % m end

local et, ew = {}, {}
local deg, sof = {}, {}
for i = 0, n - 1 do deg[i] = 0; sof[i] = 0 end

local idx = 0
for i = 0, n - 1 do
    et[idx] = (i + 1) % n; ew[idx] = 1 + ri(9); deg[i] = deg[i] + 1; idx = idx + 1
end
for i = 0, n - 1 do
    for j = 1, 5 do
        local t = ri(n); et[idx] = t; ew[idx] = 1 + ri(99); deg[i] = deg[i] + 1; idx = idx + 1
    end
end

local off = 0
for i = 0, n - 1 do sof[i] = off; off = off + deg[i] end

-- Binary heap
local hd, hn, hsz = {}, {}, 0
local function hp(d, nd)
    hn[hsz] = nd; hd[hsz] = d
    local i2 = hsz; hsz = hsz + 1
    while i2 > 0 do
        local p = math.floor((i2 - 1) / 2)
        if hd[p] <= hd[i2] then break end
        hd[i2], hd[p] = hd[p], hd[i2]
        hn[i2], hn[p] = hn[p], hn[i2]
        i2 = p
    end
end
local function hpop()
    if hsz == 0 then return -1 end
    local r = hn[0]
    hsz = hsz - 1
    hd[0], hn[0] = hd[hsz], hn[hsz]
    local i2 = 0
    while true do
        local l = 2 * i2 + 1; local r2 = 2 * i2 + 2; local s = i2
        if l < hsz and hd[l] < hd[s] then s = l end
        if r2 < hsz and hd[r2] < hd[s] then s = r2 end
        if s == i2 then break end
        hd[i2], hd[s] = hd[s], hd[i2]
        hn[i2], hn[s] = hn[s], hn[i2]
        i2 = s
    end
    return r
end

local INF = 999999999
local dist, vis = {}, {}
for i = 0, n - 1 do dist[i] = INF; vis[i] = 0 end
dist[0] = 0; hp(0, 0)

local start = os.clock()
while hsz > 0 do
    local u = hpop()
    if u < 0 then break end
    if vis[u] == 1 then goto continue end
    vis[u] = 1
    local d = dist[u]
    local base = sof[u]
    for k = 0, deg[u] - 1 do
        local v = et[base + k]
        local w = ew[base + k]
        local nd = d + w
        if nd < dist[v] then
            dist[v] = nd
            hp(nd, v)
        end
    end
    ::continue::
end

local sm = 0
for i = 0, n - 1 do sm = sm + dist[i] end
local finish = os.clock()
print("Result: " .. (sm % 1000003))
print(string.format("Time: %.0fms", (finish - start) * 1000))
