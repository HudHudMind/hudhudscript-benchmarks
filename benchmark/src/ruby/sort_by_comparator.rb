N=20000;arr=[];seed=12345;N.times{seed=(seed*16807)%2147483647;arr<<seed%1000000}
def qs(a,l,h,cmp)
 return if l>=h;s=[l,h]
 while s.any?
  h2=s.pop;l2=s.pop
  next if l2>=h2;p=a[(l2+h2)/2];i2,j2=l2,h2
  while i2<=j2
   i2+=1 while cmp.call(a[i2],p)<0;j2-=1 while cmp.call(a[j2],p)>0
   if i2<=j2;a[i2],a[j2]=a[j2],a[i2];i2+=1;j2-=1;end
  end
  if l2<j2; s.push(l2); s.push(j2); end
  if i2<h2; s.push(i2); s.push(h2); end
 end
end
asc=->a,b{a-b};desc=->a,b{b-a}
start=Time.now.to_f*1000
c1=arr.dup;qs(c1,0,N-1,asc);c2=arr.dup;qs(c2,0,N-1,desc)
r1=r2=0;N.times{|i|r1=(r1+c1[i]*(i%7))%1000003;r2=(r2+c2[i]*(i%7))%1000003}
finish=Time.now.to_f*1000
puts "Result: #{r1}_#{r2}";puts "Time: #{(finish-start).round}ms"
