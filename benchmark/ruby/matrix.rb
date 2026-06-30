size = 150
a = []
b = []
c = []
for i in 0...size
    row_a = []
    row_b = []
    row_c = []
    for j in 0...size
        row_a.push(i + j)
        row_b.push(i - j)
        row_c.push(0)
    end
    a.push(row_a)
    b.push(row_b)
    c.push(row_c)
end

start = Time.now.to_f * 1000
for i in 0...size
    for j in 0...size
        for k in 0...size
            c[i][j] = c[i][j] + a[i][k] * b[k][j]
        end
    end
end
finish = Time.now.to_f * 1000
puts "Result[0][0]: #{c[0][0]}"
puts "Result[149][149]: #{c[149][149]}"
puts "Time: #{(finish - start).round}ms"

