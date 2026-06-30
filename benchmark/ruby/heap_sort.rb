start = Time.now.to_f * 1000
arr = (1..1000).to_a.reverse
def heapify(arr, n, idx)
    largest = idx
    left = 2 * idx + 1
    right = 2 * idx + 2
    largest = left if left < n && arr[left] > arr[largest]
    largest = right if right < n && arr[right] > arr[largest]
    if largest != idx
        arr[idx], arr[largest] = arr[largest], arr[idx]
        heapify(arr, n, largest)
    end
end
n = arr.length
(n / 2 - 1).downto(0) { |j| heapify(arr, n, j) }
(n - 1).downto(1) do |k|
    arr[0], arr[k] = arr[k], arr[0]
    heapify(arr, k, 0)
end
finish = Time.now.to_f * 1000
puts "First: #{arr[0]}"
puts "Last: #{arr[-1]}"
puts "Time: #{(finish - start).round}ms"

