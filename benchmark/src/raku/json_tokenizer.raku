my $R = 20000; my $seed = 12345;
sub ri($m) { $seed = ($seed * 16807) % 2147483647; $seed % $m }
my @parts; for ^$R { my $id = ri(100000); my $tag = ri(1000); my $si = ri(1000); my $sf = ri(100);
    @parts.push('{"id":' ~ $id ~ ',"tag":"w' ~ $tag ~ '","ok":true,"score":' ~ $si ~ '.' ~ $sf ~ '}');
    @parts.push(',') if $_ < $R - 1 }
my $line = '[' ~ @parts.join ~ ']'; my ($st, $ss, $num, $kw, $pos, $L) = (0, 0, 0, 0, 0, $line.chars);
my $start = now * 1000;
while $pos < $L { my $c = $line.substr($pos, 1);
    if $c eq '{' || $c eq '}' || $c eq '[' || $c eq ']' || $c eq ':' || $c eq ',' { $st++; $pos++ }
    elsif $c eq '"' { $ss++; $pos++; $pos++ while $pos < $L && $line.substr($pos, 1) ne '"'; $pos++ }
    elsif $c eq 't' || $c eq 'f' || $c eq 'n' { $kw++; $pos += 4; $pos++ if $c eq 'f' || $c eq 'n' }
    else { $num++; $pos++ while $pos < $L && $line.substr($pos, 1) ne ',' && $line.substr($pos, 1) ne '}' && $line.substr($pos, 1) ne ']' } }
my $end = now * 1000;
say "Result: {$st}_{$ss}_{$num}_{$kw}"; say "Time: " ~ ($end - $start).Int ~ "ms";
