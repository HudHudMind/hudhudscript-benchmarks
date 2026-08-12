local n=150;local INF=999999999;local dist={}
for i=1,n do dist[i]={};for j=1,n do dist[i][j]=i==j and 0 or INF end end
local seed=12345;local function ri(m)seed=(seed*16807)%2147483647;return seed%m end
for i=1,n do for j=1,4 do local t=(i-1)*7+(j-1)*13+1;t=t%n+1;if t~=i then dist[i][t]=1+((i-1+j-1)%50)end end end
local start=os.clock()
for k=1,n do for i=1,n do local dik=dist[i][k];if dik~=INF then for j=1,n do local nd=dik+dist[k][j];if nd<dist[i][j]then dist[i][j]=nd end end end end end
local reach,sm=0,0;for i=1,n do for j=1,n do if dist[i][j]<INF then reach=reach+1;sm=sm+dist[i][j]end end end
local finish=os.clock();print("Result: "..reach.."_"..(sm%1000003));print(string.format("Time: %.0fms",(finish-start)*1000))
