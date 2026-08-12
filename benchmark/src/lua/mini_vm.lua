local I=300000;local acc=0;local c=I;local start=os.clock()
while c>0 do local op=c%10
 if op==0 then acc=(acc*3+c)%1000003;c=c-1 elseif op==1 then acc=(acc*3+c)%1000003;c=c-1 elseif op==2 then acc=(acc*3+c)%1000003;c=c-1 elseif op==3 then acc=(acc*3+c)%1000003;c=c-1 elseif op==4 then acc=(acc*3+c)%1000003;c=c-1 elseif op==5 then acc=(acc*3+c)%1000003;c=c-1 elseif op==6 then acc=(acc*3+c)%1000003;c=c-1 elseif op==7 then acc=(acc*3+c)%1000003;c=c-1 elseif op==8 then acc=(acc*3+c)%1000003;c=c-1 else acc=(acc*3+c)%1000003;c=c-1 end end
local finish=os.clock();print("Result: "..acc);print(string.format("Time: %.0fms",(finish-start)*1000))
