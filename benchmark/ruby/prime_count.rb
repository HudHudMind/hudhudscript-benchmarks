start = Time.now.to_f * 1000
count = 0
(2..100000).each do |n|
    is_p = true
    if n < 2 then is_p = false
    elsif n == 2 then is_p = true
    elsif n % 2 == 0 then is_p = false
    else
        i = 3
        while i * i <= n
            if n % i == 0
                is_p = false
                break
            end
            i += 2
        end
    end
    count += 1 if is_p
end
finish = Time.now.to_f * 1000
puts "Primes: #{count}"
puts "Time: #{(finish - start).round}ms"

