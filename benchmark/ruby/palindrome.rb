s = "a" * 50000

def is_pal(str)
    left = 0
    right = str.length - 1
    while left < right
        if str[left] != str[right]
            return false
        end
        left += 1
        right -= 1
    end
    true
end

start = Time.now.to_f * 1000
ok = true
for i in 0...1000
    ok = is_pal(s)
end
finish = Time.now.to_f * 1000
puts "Palindrome: #{ok}"
puts "Time: #{(finish - start).round}ms"

