const W=20000;let seed=12345;function ri(m){seed=(seed*16807)%2147483647;return seed%m}
let nodes=1,children=new Array(26).fill(0),terminal=[0];
function nc(){for(let i=0;i<26;i++)children.push(0);terminal.push(0);return nodes++}
const start=Date.now();
for(let w=0;w<W;w++){let l=3+ri(6),cur=0;for(let j=0;j<l;j++){let c=ri(26),idx=cur*26+c;if(children[idx]==0)children[idx]=nc();cur=children[idx]}terminal[cur]=1}
let hits=0;seed=12345;
for(let w=0;w<W;w++){let l=3+ri(6),cur=0;for(let j=0;j<l;j++){let c=ri(26),idx=cur*26+c;if(children[idx]==0){cur=0;break}cur=children[idx]}if(cur!=0&&terminal[cur]==1)hits++}
seed=54321;
for(let w=0;w<W;w++){let l=3+ri(6),cur=0;for(let j=0;j<l;j++){let c=ri(26),idx=cur*26+c;if(children[idx]==0){cur=0;break}cur=children[idx]}if(cur!=0&&terminal[cur]==1)hits++}
const end=Date.now();console.log('Result: '+nodes+'_'+hits);console.log('Time: '+Math.floor(end-start)+'ms')
