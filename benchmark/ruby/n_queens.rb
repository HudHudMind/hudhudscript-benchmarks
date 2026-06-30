start = Time.now.to_f * 1000
board = Array.new(8, 0)
count = 0
row = 0
col = 0

while true
  if row < 0
    break
  end
  if row == 8
    count += 1
    row -= 1
    if row >= 0
      col = board[row] + 1
    end
  else
    if col >= 8
      board[row] = 0
      row -= 1
      if row >= 0
        col = board[row] + 1
      end
    else
      safe = true
      i = 0
      while i < row
        if board[i] == col
          safe = false
          i = row
        else
          diff1 = board[i] - col
          if diff1 < 0
            diff1 = -diff1
          end
          diff2 = i - row
          if diff2 < 0
            diff2 = -diff2
          end
          if diff1 == diff2
            safe = false
            i = row
          else
            i += 1
          end
        end
      end
      if safe
        board[row] = col
        row += 1
        col = 0
      else
        col += 1
      end
    end
  end
end
finish = Time.now.to_f * 1000
puts "Solutions: #{count}"
puts "Time: #{(finish - start).round}ms"

