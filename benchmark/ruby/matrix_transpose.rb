size = 300
m = []
t = []
for i in 0...size
    row_m = []
    row_t = []
    for j in 0...size
        row_m.push(i + j)
        row_t.push(0)
    end
    m.push(row_m)
    t.push(row_t)
end

start = Time.now.to_f * 1000
for i in 0...size
    for j in 0...size
        t[j][i] = m[i][j]
    end
end
finish = Time.now.to_f * 1000
puts "T[0][0]: #{t[0][0]}"
puts "T[299][299]: #{t[299][299]}"
puts "Time: #{(finish - start).round}ms"

