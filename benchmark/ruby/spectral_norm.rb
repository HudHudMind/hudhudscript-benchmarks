def eval_A(i, j)
  1.0 / (((i + j) * (i + j + 1) / 2) + i + 1)
end

def eval_A_times_u(u, v, n)
  for i in 0...n
    v[i] = 0.0
    for j in 0...n
      v[i] += eval_A(i, j) * u[j]
    end
  end
end

def eval_At_times_u(u, v, n)
  for i in 0...n
    v[i] = 0.0
    for j in 0...n
      v[i] += eval_A(j, i) * u[j]
    end
  end
end

def eval_AtA_times_u(u, v, w, n)
  eval_A_times_u(u, w, n)
  eval_At_times_u(w, v, n)
end

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
n = 150
u = Array.new(n, 1.0)
v = Array.new(n, 0.0)
w = Array.new(n, 0.0)

10.times do
  eval_AtA_times_u(u, v, w, n)
  eval_AtA_times_u(v, u, w, n)
end

vBv = 0.0
vv = 0.0
for i in 0...n
  vBv += u[i] * v[i]
  vv += v[i] * v[i]
end

res = Math.sqrt(vBv / vv)
finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)

puts "Result: #{'%.9f' % res}"
puts "Time: #{((finish - start) * 1000).to_i}ms"
