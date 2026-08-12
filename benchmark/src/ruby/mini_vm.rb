I=300000;acc=0;c=I;start=Time.now.to_f*1000
while c>0;op=c%10
 if op==0;acc=(acc*3+c)%1000003;c-=1;elsif op==1;acc=(acc*3+c)%1000003;c-=1;elsif op==2;acc=(acc*3+c)%1000003;c-=1;elsif op==3;acc=(acc*3+c)%1000003;c-=1;elsif op==4;acc=(acc*3+c)%1000003;c-=1;elsif op==5;acc=(acc*3+c)%1000003;c-=1;elsif op==6;acc=(acc*3+c)%1000003;c-=1;elsif op==7;acc=(acc*3+c)%1000003;c-=1;elsif op==8;acc=(acc*3+c)%1000003;c-=1;else;acc=(acc*3+c)%1000003;c-=1;end;end
finish=Time.now.to_f*1000;puts"Result: #{acc}";puts"Time: #{(finish-start).round}ms"
