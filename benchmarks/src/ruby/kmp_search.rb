$seed=42
def rng;$seed=($seed*1103515245+12345)%2147483648;(($seed-($seed%65536))/65536)%4;end
chars="ACGT";text_arr=[];500000.times{text_arr<<chars[rng]};text=text_arr.join
patterns=[];15.times{sp=($seed*16807)%499000;$seed=($seed*16807)%2147483647;pl=5+($seed%11);patterns<<text[sp,pl]}
5.times{patterns<<"QQQQQ#{($seed*16807)%10}";$seed=($seed*16807)%2147483647}
start=Time.now.to_f*1000;total=0
patterns.each{|pat|m=pat.length;fail=Array.new(m,0);j=0
(1...m).each{|i|while j>0&&pat[i]!=pat[j];j=fail[j-1];end;if pat[i]==pat[j];j+=1;end;fail[i]=j}
j=0;text.each_char.with_index{|c,i|while j>0&&c!=pat[j];j=fail[j-1];end;if c==pat[j];j+=1;end;if j==m;total+=1;j=fail[j-1];end}}
finish=Time.now.to_f*1000;puts"Result: #{total}";puts"Time: #{(finish-start).round}ms"