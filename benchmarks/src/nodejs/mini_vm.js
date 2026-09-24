let I=300000,acc=0,c=I;
const start=Date.now();
while(c>0){let op=c%10;
 if(op==0){acc=(acc*3+c)%1000003;c--}else if(op==1){acc=(acc*3+c)%1000003;c--}else if(op==2){acc=(acc*3+c)%1000003;c--}else if(op==3){acc=(acc*3+c)%1000003;c--}else if(op==4){acc=(acc*3+c)%1000003;c--}else if(op==5){acc=(acc*3+c)%1000003;c--}else if(op==6){acc=(acc*3+c)%1000003;c--}else if(op==7){acc=(acc*3+c)%1000003;c--}else if(op==8){acc=(acc*3+c)%1000003;c--}else{acc=(acc*3+c)%1000003;c--}}
const end=Date.now();console.log('Result: '+acc);console.log('Time: '+Math.floor(end-start)+'ms')
