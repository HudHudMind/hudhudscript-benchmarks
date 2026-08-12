theta, omega, dt = 1.0, 0.0, 0.001
start = Time.now.to_f * 1000
1000000.times do
    k1t, k1o = omega, -Math.sin(theta)
    k2t, k2o = omega + 0.5*dt*k1o, -Math.sin(theta + 0.5*dt*k1t)
    k3t, k3o = omega + 0.5*dt*k2o, -Math.sin(theta + 0.5*dt*k2t)
    k4t, k4o = omega + dt*k3o, -Math.sin(theta + dt*k3t)
    theta += (dt/6.0)*(k1t + 2*k2t + 2*k3t + k4t)
    omega += (dt/6.0)*(k1o + 2*k2o + 2*k3o + k4o)
end
finish = Time.now.to_f * 1000
puts "Result: #{"%.9f" % (theta+omega)}"
puts "Time: #{(finish-start).round}ms"
