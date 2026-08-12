local seed=12345;local line=""
for j=1,40 do seed=(seed*16807)%2147483647;local fn=(seed%1000)+100;line=line.."f"..fn;if j<40 then line=line.."," end end
local R=10000;local sp,si,ss=0,0,0;local start=os.clock()
for r=1,R do local parts={};for part in line:gmatch("[^,]+") do parts[#parts+1]=part end
 for k=1,#parts do sp=sp+#parts;si=si+(parts[k]:find("f")or 1)-1;local p=parts[k];if #p>=4 then ss=ss+#p:sub(2,3) end end
end
local acc=((sp%1000003)+(si%1000003)+(ss%1000003))%1000003;local finish=os.clock()
print("Result: "..acc);print(string.format("Time: %.0fms",(finish-start)*1000))
