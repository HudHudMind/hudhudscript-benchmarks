def f3(i);raise "boom" if i%7==0;i*2;end
def f2(i);f3(i);end
def f1(i);f2(i);end
N=200000;acc=caught=0;start=Time.now.to_f*1000
(1..N).each{|i|begin;acc=(acc+f1(i))%1000003;rescue;caught+=1;end}
finish=Time.now.to_f*1000;puts "Result: #{acc}_#{caught}";puts "Time: #{(finish-start).round}ms"
