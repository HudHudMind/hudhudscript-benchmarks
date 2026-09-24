PI = 3.141592653589793
SOLAR_MASS = 4 * PI * PI
DAYS_PER_YEAR = 365.24

def advance(bodies, dt)
  n = bodies.length
  for i in 0...n
    bi = bodies[i]
    for j in (i + 1)...n
      bj = bodies[j]
      dx = bi[0] - bj[0]
      dy = bi[1] - bj[1]
      dz = bi[2] - bj[2]
      
      dsq = dx*dx + dy*dy + dz*dz
      mag = dt / (dsq * Math.sqrt(dsq))
      
      bi[3] -= dx * bj[6] * mag
      bi[4] -= dy * bj[6] * mag
      bi[5] -= dz * bj[6] * mag
      
      bj[3] += dx * bi[6] * mag
      bj[4] += dy * bi[6] * mag
      bj[5] += dz * bi[6] * mag
    end
  end
  for i in 0...n
    bi = bodies[i]
    bi[0] += dt * bi[3]
    bi[1] += dt * bi[4]
    bi[2] += dt * bi[5]
  end
end

def energy(bodies)
  e = 0.0
  n = bodies.length
  for i in 0...n
    bi = bodies[i]
    e += 0.5 * bi[6] * (bi[3]*bi[3] + bi[4]*bi[4] + bi[5]*bi[5])
    for j in (i + 1)...n
      bj = bodies[j]
      dx = bi[0] - bj[0]
      dy = bi[1] - bj[1]
      dz = bi[2] - bj[2]
      e -= (bi[6] * bj[6]) / Math.sqrt(dx*dx + dy*dy + dz*dz)
    end
  end
  e
end

bodies = [
  [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS],
  [4.84143144246472090, -1.16032004402742839, -0.103622044471123109,
   1.66007664274403694e-03 * DAYS_PER_YEAR, 7.69901118419740425e-03 * DAYS_PER_YEAR, -6.90460016972063023e-05 * DAYS_PER_YEAR,
   9.54791938424326609e-04 * SOLAR_MASS],
  [8.34336671824457987, 4.12479856412430479, -0.403523417114321381,
   -2.76742510726862411e-03 * DAYS_PER_YEAR, 4.99852801234917238e-03 * DAYS_PER_YEAR, 2.30417297573763929e-05 * DAYS_PER_YEAR,
   2.85885980666130812e-04 * SOLAR_MASS],
  [12.8943695621391310, -15.1111514016986312, -0.223307578892655734,
   2.96460137564761618e-03 * DAYS_PER_YEAR, 2.37847173959480950e-03 * DAYS_PER_YEAR, -2.96589568540237556e-05 * DAYS_PER_YEAR,
   4.36624404335156298e-05 * SOLAR_MASS],
  [15.3796971148509165, -25.9193146099879641, 0.179258772950371181,
   2.68067772490389322e-03 * DAYS_PER_YEAR, 1.62824170038242295e-03 * DAYS_PER_YEAR, -9.51592254519715870e-05 * DAYS_PER_YEAR,
   5.15138902046611451e-05 * SOLAR_MASS]
]

px = py = pz = 0.0
bodies.each do |b|
  px += b[3] * b[6]
  py += b[4] * b[6]
  pz += b[5] * b[6]
end
bodies[0][3] = -px / SOLAR_MASS
bodies[0][4] = -py / SOLAR_MASS
bodies[0][5] = -pz / SOLAR_MASS

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
e1 = energy(bodies)
10000.times { advance(bodies, 0.01) }
e2 = energy(bodies)
finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)

puts "Result: #{'%.9f' % e1}_#{'%.9f' % e2}"
puts "Time: #{((finish - start) * 1000).to_i}ms"
