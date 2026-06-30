n = 100
adj = Array.new(n) { Array.new(n, 0) }
n.times do |i|
    n.times do |j|
        adj[i][j] = 1 if (i * 3 + j * 7) % 11 == 0 && i != j
    end
end
start = Time.now.to_f * 1000
visited = Array.new(n, false)
queue = [0]
head = 0
count = 0
while head < queue.length
    node = queue[head]
    head += 1
    next if visited[node]
    visited[node] = true
    count += 1
    n.times do |neighbor|
        queue.push(neighbor) if adj[node][neighbor] == 1 && !visited[neighbor]
    end
end
finish = Time.now.to_f * 1000
puts "Visited: #{count}"
puts "Time: #{(finish - start).round}ms"

