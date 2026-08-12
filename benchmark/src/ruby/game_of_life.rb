G=96;T=100;seed=12345;def ri(m);$seed=($seed*16807)%2147483647;$seed%m;end;$seed=12345
a=Array.new(G){Array.new(G){ri(100)<35?1:0}};b=Array.new(G){Array.new(G,0)}
start=Time.now.to_f*1000
T.times{G.times{|i|G.times{|j|nbr=0
 (-1..1).each{|di|(-1..1).each{|dj|next if di==0&&dj==0;nbr+=a[(i+di)%G][(j+dj)%G]}}
 b[i][j]=(a[i][j]==1&&(nbr==2||nbr==3))||(a[i][j]==0&&nbr==3)?1:0}};a,b=b,a}
alive=0;G.times{|i|G.times{|j|alive+=a[i][j]}}
finish=Time.now.to_f*1000;puts"Result: #{alive}";puts"Time: #{(finish-start).round}ms"
