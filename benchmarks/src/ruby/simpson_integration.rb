def f(x);x*x*x-2*x*x+3;end
N=2000000;h=10.0/N;s=f(0)+f(10)
start=Time.now.to_f*1000
(1...N).each{|i|x=i*h;s+=i%2==0 ?2*f(x):4*f(x)}
r=s*h/3;finish=Time.now.to_f*1000
puts"Result: #{r}";puts"Time: #{(finish-start).round}ms"
