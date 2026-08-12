n=200;A=Array.new(n){|i|Array.new(n){|j|((i*31+j*17)%100+1)+(i==j ?1000:0)}}
start=Time.now.to_f*1000
n.times{|k|(k+1...n).each{|i|f=A[i][k].to_f/A[k][k];n.times{|j|A[i][j]-=f*A[k][j]};A[i][k]=f}}
s=0;n.times{|i|s+=A[i][i]};r=(s/n*1000).round
finish=Time.now.to_f*1000;puts"Result: #{r}";puts"Time: #{(finish-start).round}ms"