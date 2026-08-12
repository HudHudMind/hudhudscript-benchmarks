local N=20000;local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local arr={};for i=1,N do arr[i]="w"..ri(100000) end
local function ms(a) local sz=#a;if sz<=1 then return a end;local md=math.floor(sz/2);local L,R={},{};for i=1,md do L[i]=a[i]end;for i=md+1,sz do R[i-md]=a[i]end;L=ms(L);R=ms(R);local res,pi,qi={},1,1
 while pi<=#L do if qi>#R then break end;if L[pi]<=R[qi]then res[#res+1]=L[pi];pi=pi+1 else res[#res+1]=R[qi];qi=qi+1 end end
 while pi<=#L do res[#res+1]=L[pi];pi=pi+1 end;while qi<=#R do res[#res+1]=R[qi];qi=qi+1 end;return res end
local start=os.clock();local s=ms(arr);local acc=0;for i=1,N do acc=(acc+#s[i]*((i-1)%13))%1000003 end
local finish=os.clock();print("Result: "..acc);print(string.format("Time: %.0fms",(finish-start)*1000))
