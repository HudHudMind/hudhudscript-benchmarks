class Shape
    def score; 0; end
end

class A < Shape
    def score; @v * 2; end
end

class B < Shape
    def score; @v * 3 + 1; end
end

class C < Shape
    def score; @v * 5 - 2; end
end

shapes = []
3000.times do |i|
    r = i % 3
    obj = case r
        when 0 then A.new
        when 1 then B.new
        else C.new
    end
    obj.instance_variable_set(:@v, i % 97)
    shapes << obj
end

P = 300
acc = 0
start = Time.now.to_f * 1000
P.times do
    shapes.each { |s| acc = (acc + s.score) % 1000003 }
end
finish = Time.now.to_f * 1000
puts "Result: #{acc}"
puts "Time: #{(finish - start).round}ms"
