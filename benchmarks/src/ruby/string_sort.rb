N=20000;seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
arr=N.times.map{"w#{ri(100000)}"}
def ms(a) return a if a.length<=1;m=a.length/2;l=ms(a[0...m]);r=ms(a[m..]);res=[];pi=qi=0
 while pi<l.length;break if qi>=r.length;res<<(l[pi]<=r[qi] ? l[pi] : r[qi]);l[pi]<=r[qi] ? pi+=1 : qi+=1 end
 res.concat(l[pi..]);res.concat(r[qi..]);res end
start=Time.now.to_f*1000;s=ms(arr);acc=0;N.times{|i|acc=(acc+s[i].length*(i%13))%1000003}
finish=Time.now.to_f*1000;puts"Result: #{acc}";puts"Time: #{(finish-start).round}ms"
