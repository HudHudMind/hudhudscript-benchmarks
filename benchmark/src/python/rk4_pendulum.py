import time, math
theta = 1.0; omega = 0.0; dt = 0.001
start = time.time() * 1000
for _ in range(1000000):
    k1t = omega; k1o = -math.sin(theta)
    k2t = omega + 0.5*dt*k1o; k2o = -math.sin(theta + 0.5*dt*k1t)
    k3t = omega + 0.5*dt*k2o; k3o = -math.sin(theta + 0.5*dt*k2t)
    k4t = omega + dt*k3o; k4o = -math.sin(theta + dt*k3t)
    theta += (dt/6.0)*(k1t + 2*k2t + 2*k3t + k4t)
    omega += (dt/6.0)*(k1o + 2*k2o + 2*k3o + k4o)
end = time.time() * 1000
print(f"Result: {theta+omega:.9f}")
print(f"Time: {int(end - start)}ms")
