n=100000;total=0;start=Time.now.to_f*1000
(1..n).each{|i|x=i;while x>0;total+=x%2;x/=2;end}
finish=Time.now.to_f*1000;puts"Result: #{total}";puts"Time: #{(finish-start).round}ms"