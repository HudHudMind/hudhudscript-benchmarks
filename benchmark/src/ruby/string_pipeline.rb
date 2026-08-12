seed=12345;line="";40.times{|j|seed=(seed*16807)%2147483647;fn=(seed%1000)+100;line+="f#{fn}";line+="," if j<39}
R=10000;sp=si=ss=0;start=Time.now.to_f*1000
R.times{parts=line.split(",");parts.each{|p|sp+=parts.length;si+=p.index("f")||0;ss+=p[1,2].length if p.length>=4}}
acc=((sp%1000003)+(si%1000003)+(ss%1000003))%1000003;finish=Time.now.to_f*1000
puts "Result: #{acc}";puts "Time: #{(finish-start).round}ms"
