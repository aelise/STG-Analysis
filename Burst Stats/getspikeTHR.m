function [spikeTHR] = getspikeTHR(x1,x2,filename,ch_index, datname)

load(filename, datname);
if ~strcmp(datname ,'dat')
    eval(['dat=' datname '; clear ' datname ';']);
end

totchnum=length(ch_index);
if totchnum==2
    ch_index=[ch_index(1) ch_index ch_index(1)];
else
    ch_index=[ch_index(1) ch_index ch_index(1) ch_index(1)];
end
spikeTHR=zeros(4,1);
    
for i=1:4
    chnum =ch_index(i);
    plot(dat(x1:x2,chnum))
    [~,y] = ginput(1);
    spikeTHR(i)=y;
end

spikeTHR

end