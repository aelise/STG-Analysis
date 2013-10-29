%script for adjusting time values when
%(1) you want to start the experiment at zero time
%or (2) you want to account for a switch in filenames/reference time
%assumes there was no (or a minor) break between filenames

temp=find(LP.bstat(:,1)<0.001);
L=length(LP.bstat(:,1));
LP.bstat(1:temp(1)-1,1)=LP.bstat(1:temp(1)-1,1)-LP.bstat(1,1);
LP.bstat(temp(1):L,1)=LP.bstat(temp(1):L,1)+LP.bstat(temp(1)-1,1);

temp=find(PD.bstat(:,1)<0.001);
L=length(PD.bstat(:,1));
PD.bstat(1:temp(1)-1,1)=PD.bstat(1:temp(1)-1,1)-PD.bstat(1,1);
PD.bstat(temp(1):L,1)=PD.bstat(temp(1):L,1)+PD.bstat(temp(1)-1,1);

temp=find(PY.bstat(:,1)<0.001);
L=length(PY.bstat(:,1));
PY.bstat(1:temp(1)-1,1)=PY.bstat(1:temp(1)-1,1)-PY.bstat(1,1);
PY.bstat(temp(1):L,1)=PY.bstat(temp(1):L,1)+PY.bstat(temp(1)-1,1);