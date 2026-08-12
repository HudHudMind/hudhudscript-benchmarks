let theta = 1.0, omega = 0.0, dt = 0.001;
const start = Date.now();
for (let i = 0; i < 1000000; i++) {
    const k1t = omega, k1o = -Math.sin(theta);
    const k2t = omega + 0.5*dt*k1o, k2o = -Math.sin(theta + 0.5*dt*k1t);
    const k3t = omega + 0.5*dt*k2o, k3o = -Math.sin(theta + 0.5*dt*k2t);
    const k4t = omega + dt*k3o, k4o = -Math.sin(theta + dt*k3t);
    theta += (dt/6.0)*(k1t + 2*k2t + 2*k3t + k4t);
    omega += (dt/6.0)*(k1o + 2*k2o + 2*k3o + k4o);
}
const end = Date.now();
console.log(`Result: ${(theta+omega).toFixed(9)}`);
console.log(`Time: ${end - start}ms`);
