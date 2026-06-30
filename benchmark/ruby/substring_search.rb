text = ""
for i in 1..1000
    text = text + "abcdefghij"
end
pattern = "defg"
text_len = text.length
pat_len = pattern.length
count = 0
start = Time.now.to_f * 1000
for t in 0..(text_len - pat_len)
    match = true
    for p in 0..(pat_len - 1)
        if text[t + p] != pattern[p]
            match = false
            break
        end
    end
    if match
        count = count + 1
    end
end
finish = Time.now.to_f * 1000
puts "Count: #{count}"
puts "Time: #{(finish - start).round}ms"
