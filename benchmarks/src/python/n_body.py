PI = 3.141592653589793
SOLAR_MASS = 4 * PI * PI
DAYS_PER_YEAR = 365.24

def advance(bodies, dt):
    for i in range(len(bodies)):
        body_i = bodies[i]
        for j in range(i + 1, len(bodies)):
            body_j = bodies[j]
            dx = body_i[0] - body_j[0]
            dy = body_i[1] - body_j[1]
            dz = body_i[2] - body_j[2]
            
            distance_sq = dx*dx + dy*dy + dz*dz
            mag = dt / (distance_sq * (distance_sq ** 0.5))
            
            body_i[3] -= dx * body_j[6] * mag
            body_i[4] -= dy * body_j[6] * mag
            body_i[5] -= dz * body_j[6] * mag
            
            body_j[3] += dx * body_i[6] * mag
            body_j[4] += dy * body_i[6] * mag
            body_j[5] += dz * body_i[6] * mag
            
    for body in bodies:
        body[0] += dt * body[3]
        body[1] += dt * body[4]
        body[2] += dt * body[5]

def energy(bodies):
    e = 0.0
    for i in range(len(bodies)):
        body_i = bodies[i]
        e += 0.5 * body_i[6] * (body_i[3]*body_i[3] + body_i[4]*body_i[4] + body_i[5]*body_i[5])
        for j in range(i + 1, len(bodies)):
            body_j = bodies[j]
            dx = body_i[0] - body_j[0]
            dy = body_i[1] - body_j[1]
            dz = body_i[2] - body_j[2]
            distance = (dx*dx + dy*dy + dz*dz) ** 0.5
            e -= (body_i[6] * body_j[6]) / distance
    return e

def main(n):
    # Format: [x, y, z, vx, vy, vz, mass]
    bodies = [
        # Sun
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS],
        # Jupiter
        [4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
         1.66007664274403694e-03 * DAYS_PER_YEAR, 7.69901118419740425e-03 * DAYS_PER_YEAR, -6.90460016972063023e-05 * DAYS_PER_YEAR,
         9.54791938424326609e-04 * SOLAR_MASS],
        # Saturn
        [8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
         -2.76742510726862411e-03 * DAYS_PER_YEAR, 4.99852801234917238e-03 * DAYS_PER_YEAR, 2.30417297573763929e-05 * DAYS_PER_YEAR,
         2.85885980666130812e-04 * SOLAR_MASS],
        # Uranus
        [1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
         2.96460137564761618e-03 * DAYS_PER_YEAR, 2.37847173959480950e-03 * DAYS_PER_YEAR, -2.96589568540237556e-05 * DAYS_PER_YEAR,
         4.36624404335156298e-05 * SOLAR_MASS],
        # Neptune
        [1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
         2.68067772490389322e-03 * DAYS_PER_YEAR, 1.62824170038242295e-03 * DAYS_PER_YEAR, -9.51592254519715870e-05 * DAYS_PER_YEAR,
         5.15138902046611451e-05 * SOLAR_MASS]
    ]

    px, py, pz = 0.0, 0.0, 0.0
    for b in bodies:
        px += b[3] * b[6]
        py += b[4] * b[6]
        pz += b[5] * b[6]
    bodies[0][3] = -px / SOLAR_MASS
    bodies[0][4] = -py / SOLAR_MASS
    bodies[0][5] = -pz / SOLAR_MASS

    e1 = energy(bodies)
    for _ in range(n):
        advance(bodies, 0.01)
    e2 = energy(bodies)
    return e1, e2

import time
start = time.time()
e1, e2 = main(10000)
end = time.time()
print(f"Result: {e1:.9f}_{e2:.9f}")
print(f"Time: {int((end - start)*1000)}ms")
