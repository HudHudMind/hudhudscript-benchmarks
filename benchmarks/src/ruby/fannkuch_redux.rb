def fannkuch(n)
  p = (0...n).to_a
  q = (0...n).to_a
  s = (0...n).to_a
  sign = 1
  maxflips = 0
  sumflips = 0

  while true
    q1 = p[0]
    if q1 != 0
      for i in 1...n do q[i] = p[i] end
      flips = 1
      while true
        qq = q[q1]
        break if qq == 0
        q[q1] = q1
        if q1 >= 3
          i, j = 1, q1 - 1
          while i < j
            q[i], q[j] = q[j], q[i]
            i += 1
            j -= 1
          end
        end
        q1 = qq
        flips += 1
      end
      maxflips = flips if flips > maxflips
      sumflips += sign * flips
    end

    if sign == 1
      p[1], p[0] = p[0], p[1]
      sign = -1
    else
      p[1], p[2] = p[2], p[1]
      sign = 1
      k = 2
      while k < n
        s[k] -= 1
        break if s[k] != 0
        s[k] = k
        t = p[0]
        for m in 0..k
          p[m] = m < k ? p[m + 1] : t
        end
        k += 1
      end
      break if k == n
    end
  end
  return "#{sumflips}_#{maxflips}"
end

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
res = fannkuch(9)
finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)

puts "Result: #{res}"
puts "Time: #{((finish - start) * 1000).to_i}ms"
