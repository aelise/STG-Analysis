function [av,st,pts]=tlimavg(dat,ts,t1,t2)
%time limited average
%dat is the matfile, assume col 2 is time
%t1 and t2 are the time constraints (t1<t2)
%col is the column you want an average of

temp=dat(ts>t1 & ts<t2);
av=mean(temp);
st=std(temp);
pts=length(temp);

