def mandelbrot(size)
  sum_iters = 0
  (0...size).each do |y|
    (0...size).each do |x|
      zr = 0.0
      zi = 0.0
      cr = (2.0 * x / size) - 1.5
      ci = (2.0 * y / size) - 1.0
      escape = 0
      50.times do
        tr = zr * zr - zi * zi + cr
        ti = 2.0 * zr * zi + ci
        zr = tr
        zi = ti
        if zr * zr + zi * zi > 4.0
          escape = 1
          break
        end
      end
      sum_iters += escape
    end
  end
  sum_iters
end

start_time = Time.now.to_f * 1000
res = mandelbrot(500)
end_time = Time.now.to_f * 1000

puts "Sum: #{res}"
puts "Time: #{(end_time - start_time).to_i}ms"
