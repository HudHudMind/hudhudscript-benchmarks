M=500000;seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
dict=(0...2000).map{|i|"w#{i}"}
counts={};dict.each{|w|counts[w]=0}
start=Time.now.to_f*1000
M.times{counts[dict[ri(2000)]]+=1}
mc=0;mw="";dict.each{|w|v=counts[w];mc=mw==""||v>mc ?(mc=v;mw=w;mc):mc}
finish=Time.now.to_f*1000
puts"Result: #{mc}_#{mw}";puts"Time: #{(finish-start).round}ms"
