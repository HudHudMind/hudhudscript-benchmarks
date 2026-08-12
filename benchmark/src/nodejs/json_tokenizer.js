const R=20000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let parts=[];for(let i=0;i<R;i++){let id=ri(100000),tag=ri(1000),si=ri(1000),sf=ri(100);
 parts.push('{\"id\":'+id+',\"tag\":\"w'+tag+'\",\"ok\":true,\"score\":'+si+'.'+sf+'}');if(i<R-1)parts.push(',')}
let line='['+parts.join('')+']',st=0,ss=0,num=0,kw=0,pos=0,L=line.length;
const start=Date.now();
while(pos<L){let c=line[pos];
 if('{[}]:,'.includes(c)){st++;pos++}else if(c=='\"'){ss++;pos++;
  while(pos<L&&line[pos]!='\"')pos++;pos++}else if('tfn'.includes(c)){kw++;pos+=4;
  if('fn'.includes(c))pos++}else{num++;while(pos<L&&!',}]'.includes(line[pos]))pos++}}
const end=Date.now();console.log('Result: '+st+'_'+ss+'_'+num+'_'+kw);console.log('Time: '+Math.floor(end-start)+'ms')
