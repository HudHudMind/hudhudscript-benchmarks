start = Time.now.to_f * 1000
arr = (1..1000).to_a.reverse
n = arr.length
width = 1
while width < n
    left = 0
    while left < n
        mid = left + width - 1
        if mid < n - 1
            right = left + 2 * width - 1
            right = n - 1 if right >= n
            n1 = mid - left + 1
            n2 = right - mid
            l = []
            r = []
            n1.times { |k| l << arr[left + k] }
            n2.times { |k| r << arr[mid + 1 + k] }
            i = j = 0
            m = left
            while i < n1 && j < n2
                if l[i] <= r[j]
                    arr[m] = l[i]
                    i += 1
                else
                    arr[m] = r[j]
                    j += 1
                end
                m += 1
            end
            while i < n1
                arr[m] = l[i]
                i += 1
                m += 1
            end
            while j < n2
                arr[m] = r[j]
                j += 1
                m += 1
            end
        end
        left += 2 * width
    end
    width *= 2
end
finish = Time.now.to_f * 1000
puts "First: #{arr[0]}"
puts "Last: #{arr[-1]}"
puts "Time: #{(finish - start).round}ms"

