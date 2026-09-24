<?php
$R=20000;$seed=12345;function ri($m){global$seed;$seed=($seed*16807)%2147483647;return$seed%$m;}
$parts=[];for($i=0;$i<$R;$i++){$id=ri(100000);$tag=ri(1000);$si=ri(1000);$sf=ri(100);
 $parts[]='{"id":'.$id.',"tag":"w'.$tag.'","ok":true,"score":'.$si.'.'.$sf.'}';if($i<$R-1)$parts[]=',';}
$line='['.join('',$parts).']';$st=$ss=$num=$kw=0;$pos=0;$L=strlen($line);$start=hrtime(true);
while($pos<$L){$c=$line[$pos];
 if(strpos('{[}]:,',$c)!==false){$st++;$pos++;}
 elseif($c=='"'){$ss++;$pos++;while($pos<$L&&$line[$pos]!='"')$pos++;$pos++;}
 elseif(strpos('tfn',$c)!==false){$kw++;$pos+=4;if(strpos('fn',$c)!==false)$pos++;}
 else{$num++;while($pos<$L&&strpos(',}]',$line[$pos])===false)$pos++;}}
$end=hrtime(true);$ms=($end-$start)/1e6;echo"Result: {$st}_{$ss}_{$num}_{$kw}\n";echo"Time: ".round($ms)."ms\n";