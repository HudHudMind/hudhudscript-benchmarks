local N=4096;local PI=3.141592653589793;local re,im={},{}
for i=1,N do re[i]=math.sin((i-1)*0.017)+0.5*math.sin((i-1)*0.31);im[i]=0 end
local br={};for i=1,N do local rev=0;local p2=1;for j=1,12 do rev=rev*2+math.floor((i-1)/p2)%2;p2=p2*2 end;br[i]=rev+1 end
local R=50;local fs=0;local start=os.clock()
for r=1,R do local cr,ci={},{};for i=1,N do local b=br[i];cr[i]=re[b];ci[i]=im[b]end
 local step=2;while step<=N do local half=step/2;local ang=(-2*PI)/step;local wr=math.cos(ang);local wi=math.sin(ang)
  local k=1;while k<=N do local twr=1;local twi=0
   for m=1,half do local ei=k+m-1;local oi=k+m-1+half;local tr=twr*cr[oi]-twi*ci[oi];local ti=twr*ci[oi]+twi*cr[oi]
    cr[oi]=cr[ei]-tr;ci[oi]=ci[ei]-ti;cr[ei]=cr[ei]+tr;ci[ei]=ci[ei]+ti
    local nwr=twr;twr=nwr*wr-twi*wi;twi=nwr*wi+twi*wr end;k=k+step end;step=step*2 end
 local sm=0;for i=1,N do sm=sm+cr[i]*cr[i]+ci[i]*ci[i]end;fs=sm end
local finish=os.clock();print("Result: "..math.floor(fs+0.5));print(string.format("Time: %.0fms",(finish-start)*1000))