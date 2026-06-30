n = 100
adj = []
n.times do |i|
    row = []
    n.times do |j|
        row << 0
    end
    adj << row
end
n.times do |i|
    n.times do |j|
        if (i * 3 + j * 7) % 11 == 0
            if i != j
                adj[i][j] = 1
            end
        end
    end
end
start = Time.now.to_f * 1000
visited = []
n.times do |i|
    visited << false
end
stack = [0]
count = 0
while true
    if stack.empty?
        break
    end
    node = stack.pop
    if not visited[node]
        visited[node] = true
        count = count + 1
        (n - 1).downto(0) do |neighbor|
            if adj[node][neighbor] == 1
                if not visited[neighbor]
                    stack.push(neighbor)
                end
            end
        end
    end
end
finish = Time.now.to_f * 1000
puts "Visited: #{count}"
puts "Time: #{(finish - start).round}ms"

