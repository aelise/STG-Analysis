function [a,s,t] = MINtlimavg(ts,dat,start,end_t)
%Example: LPindex=LP.bstat(:,3)>0;  
% LPts=LP.bstat(LPindex,1); 
% LPper=LP.bstat(LPindex,5); 
% LPf=1./LPper;
% MAXtlimavg(LPts,LPf,25) %LPts and start time in hours

t=0;
a=500;
s=0;

b=5; %BLOCK SIZE (in hours) CHANGE if needed

if nargin<4
    end_t=floor(ts(length(ts)))-b;
end

for x = start:0.5:end_t
    temp=dat(ts>x & ts<(x+b));
    av=mean(temp);
    st=std(temp);
    pts=length(temp);
    if av<a && pts>500 %another option: st< some value
        a=av;
        s=st;
        t=x;
    end
end