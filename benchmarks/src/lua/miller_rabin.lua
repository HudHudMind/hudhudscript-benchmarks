local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
local function pm(b,e,m)local r=1;while e>0 do if e%2==1 then r=(r*b)%m end;e=e//2;b=(b*b)%m end;return r end
local function ip(n)if n<2 then return 0 elseif n==2 then return 1 elseif n%2==0 then return 0 end
 local d=n-1;local s=0;while d%2==0 do d=d//2;s=s+1 end
 for _,a in ipairs{2,3,5,7} do if a>=n then goto cont end;local x=pm(a,d,n);if x==1 or x==n-1 then goto cont end
  for r=1,s-1 do x=(x*x)%n;if x==n-1 then break end end;if x~=n-1 then return 0 end;::cont::end;return 1 end
local K=2000;local cnt=0;local start=os.clock()
for _=1,K do local n=1000000001+2*ri(500000000);if ip(n)==1 then cnt=cnt+1 end end
local finish=os.clock();print("Result: "..cnt);print(string.format("Time: %.0fms",(finish-start)*1000))
