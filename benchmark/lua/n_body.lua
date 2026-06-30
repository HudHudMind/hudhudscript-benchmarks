local PI = 3.141592653589793
local SOLAR_MASS = 4 * PI * PI
local DAYS_PER_YEAR = 365.24

local function advance(bodies, dt)
    local n = #bodies
    for i = 1, n do
        local bi = bodies[i]
        for j = i + 1, n do
            local bj = bodies[j]
            local dx = bi[1] - bj[1]
            local dy = bi[2] - bj[2]
            local dz = bi[3] - bj[3]
            
            local dsq = dx*dx + dy*dy + dz*dz
            local mag = dt / (dsq * math.sqrt(dsq))
            
            bi[4] = bi[4] - dx * bj[7] * mag
            bi[5] = bi[5] - dy * bj[7] * mag
            bi[6] = bi[6] - dz * bj[7] * mag
            
            bj[4] = bj[4] + dx * bi[7] * mag
            bj[5] = bj[5] + dy * bi[7] * mag
            bj[6] = bj[6] + dz * bi[7] * mag
        end
    end
    for i = 1, n do
        local bi = bodies[i]
        bi[1] = bi[1] + dt * bi[4]
        bi[2] = bi[2] + dt * bi[5]
        bi[3] = bi[3] + dt * bi[6]
    end
end

local function energy(bodies)
    local e = 0.0
    local n = #bodies
    for i = 1, n do
        local bi = bodies[i]
        e = e + 0.5 * bi[7] * (bi[4]*bi[4] + bi[5]*bi[5] + bi[6]*bi[6])
        for j = i + 1, n do
            local bj = bodies[j]
            local dx = bi[1] - bj[1]
            local dy = bi[2] - bj[2]
            local dz = bi[3] - bj[3]
            local distance = math.sqrt(dx*dx + dy*dy + dz*dz)
            e = e - (bi[7] * bj[7]) / distance
        end
    end
    return e
end

local bodies = {
    {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS},
    {4.84143144246472090, -1.16032004402742839, -0.103622044471123109,
     1.66007664274403694 * 1e-3 * DAYS_PER_YEAR, 7.69901118419740425 * 1e-3 * DAYS_PER_YEAR, -6.90460016972063023 * 1e-5 * DAYS_PER_YEAR,
     9.54791938424326609 * 1e-4 * SOLAR_MASS},
    {8.34336671824457987, 4.12479856412430479, -0.403523417114321381,
     -2.76742510726862411 * 1e-3 * DAYS_PER_YEAR, 4.99852801234917238 * 1e-3 * DAYS_PER_YEAR, 2.30417297573763929 * 1e-5 * DAYS_PER_YEAR,
     2.85885980666130812 * 1e-4 * SOLAR_MASS},
    {12.8943695621391310, -15.1111514016986312, -0.223307578892655734,
     2.96460137564761618 * 1e-3 * DAYS_PER_YEAR, 2.37847173959480950 * 1e-3 * DAYS_PER_YEAR, -2.96589568540237556 * 1e-5 * DAYS_PER_YEAR,
     4.36624404335156298 * 1e-5 * SOLAR_MASS},
    {15.3796971148509165, -25.9193146099879641, 0.179258772950371181,
     2.68067772490389322 * 1e-3 * DAYS_PER_YEAR, 1.62824170038242295 * 1e-3 * DAYS_PER_YEAR, -9.51592254519715870 * 1e-5 * DAYS_PER_YEAR,
     5.15138902046611451 * 1e-5 * SOLAR_MASS}
}

local px, py, pz = 0.0, 0.0, 0.0
for i = 1, #bodies do
    local b = bodies[i]
    px = px + b[4] * b[7]
    py = py + b[5] * b[7]
    pz = pz + b[6] * b[7]
end
bodies[1][4] = -px / SOLAR_MASS
bodies[1][5] = -py / SOLAR_MASS
bodies[1][6] = -pz / SOLAR_MASS

local start = os.clock() * 1000
local e1 = energy(bodies)
for i = 1, 10000 do
    advance(bodies, 0.01)
end
local e2 = energy(bodies)
local end_time = os.clock() * 1000

print(string.format("Result: %.9f_%.9f", e1, e2))
print("Time: " .. math.floor(end_time - start) .. "ms")
