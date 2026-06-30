def tak(x, y, z)
  if y < x
    tak(
      tak(x - 1, y, z),
      tak(y - 1, z, x),
      tak(z - 1, x, y)
    )
  else
    z
  end
end

start_time = Time.now.to_f * 1000
res = 0
10.times do
  res = tak(18, 12, 6)
end
end_time = Time.now.to_f * 1000

puts "Result: #{res}"
puts "Time: #{(end_time - start_time).to_i}ms"
