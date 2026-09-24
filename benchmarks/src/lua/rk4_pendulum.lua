local theta, omega, dt = 1.0, 0.0, 0.001
local start = os.clock()
for _ = 1, 1000000 do
    local k1t, k1o = omega, -math.sin(theta)
    local k2t, k2o = omega + 0.5*dt*k1o, -math.sin(theta + 0.5*dt*k1t)
    local k3t, k3o = omega + 0.5*dt*k2o, -math.sin(theta + 0.5*dt*k2t)
    local k4t, k4o = omega + dt*k3o, -math.sin(theta + dt*k3t)
    theta = theta + (dt/6.0)*(k1t + 2*k2t + 2*k3t + k4t)
    omega = omega + (dt/6.0)*(k1o + 2*k2o + 2*k3o + k4o)
end
local finish = os.clock()
print(string.format("Result: %.9f", theta + omega))
print(string.format("Time: %.0fms", (finish - start) * 1000))
