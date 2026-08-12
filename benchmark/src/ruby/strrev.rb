n=50000;s="a"*n;start=Time.now.to_f*1000
buf=[];(n-1).downto(0){|i|buf<<s[i]};r=buf.join
finish=Time.now.to_f*1000;puts"Result: #{r[0]}/#{r.length}";puts"Time: #{(finish-start).round}ms"