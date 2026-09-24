N=4096;PI=3.141592653589793;re=N.times.map{|i|Math.sin(i*0.017)+0.5*Math.sin(i*0.31)};im=[0.0]*N
br=N.times.map{|i|rev=0;p2=1;12.times{rev=rev*2+(i/p2)%2;p2*=2};rev}
R=50;fs=0;start=Time.now.to_f*1000
R.times{cr=[];ci=[];N.times{|i|b=br[i];cr<<re[b];ci<<im[b]}
 step=2;while step<=N;half=step/2;ang=(-2*PI)/step;wr=Math.cos(ang);wi=Math.sin(ang)
  k=0;while k<N;twr=1;twi=0;half.times{|m|ei=k+m;oi=k+m+half;tr=twr*cr[oi]-twi*ci[oi];ti=twr*ci[oi]+twi*cr[oi]
   cr[oi]=cr[ei]-tr;ci[oi]=ci[ei]-ti;cr[ei]+=tr;ci[ei]+=ti;nwr=twr;twr=nwr*wr-twi*wi;twi=nwr*wi+twi*wr};k+=step;end;step*=2;end
 sm=0;N.times{|i|sm+=cr[i]*cr[i]+ci[i]*ci[i]};fs=sm}
finish=Time.now.to_f*1000;puts"Result: #{fs.round}";puts"Time: #{(finish-start).round}ms"