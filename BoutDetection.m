function []=BoutDetection()

global PD LP

%% init
PDindex=PD.bstat(:,3)>0; %burst start indicies
PDper=PD.bstat(PDindex,5); PDf=1./PDper;
PDts=PD.bstat(PDindex,1);

recovery=0; % indicator if recovery has happened
bouts=zeros(length(PDper),2); % bout indicies 

%% find start-stop times graphically (units: burst indicies in PDper)
figure(1)
plot(PDf,'.')
ylim([0 2]);
[x,~] = ginput(2);
[x1]=x(1);
[x2]=x(2);

%% Loop: check for bout, still in bout?, increment, repeat 
PDff=medfilt1(PDf,3);
w=50; rw=1000;%init window length (~7 min in hrs =0.1167)
timecheck=PDts(w)-PDts(1); timecheckrw=PDts(rw)-PDts(1); 
while timecheckrw<5
    rw=rw+50;
    timecheckrw=PDts(rw)-PDts(1);
end

for n=rw:ceil(x2) 
    %check bout window length
    while timecheck<0.1167 %(~7 min in hrs =0.1167)
        w=w+50;
        timecheck=PDts(n)-PDts(n-w);
    end
    while timecheck>0.1167
        w=w-50;
        timecheck=PDts(n)-PDts(n-w);
    end
    
    if w<50
        w=50;
    end
    
    %check recovery window length
    timecheckrw=PDts(n+0.5*rw)-PDts(n-0.5*rw);
    while timecheckrw<5
        rw=rw+50;
        timecheckrw=PDts(n+0.5*rw)-PDts(n-0.5*rw);
    end
    while timecheckrw>5
        rw=rw-50;
        timecheckrw=PDts(n+0.5*rw)-PDts(n-0.5*rw);
    end
    
    if rw<50
        rw=50;
    end
    
    %check for cntrl/interbout/bout/recovery
    boutcheck=mean(PDff(n-w:n));
    if n<x1  %cntrl conditions =1
        bouts(n,:)=[n 1];
    elseif n>x1 && n<(x1+rw+500)
    elseif mean(PDff(n-0.5*rw:n+0.5*rw))>0.2 && std(PDff(n-0.5*rw:n+0.5*rw))<0.1  %recovery=4
        bouts(n,:)=[n 4];
        recovery=1;
    elseif PDff(n:n+3)>(boutcheck+boutcheck*.4) %in bout=3
        bouts(n,:)=[n 3]; 
    elseif recovery==0 
        bouts(n,:)=[n 2]; %before recovery, interbout=2
    end
    
end

%% Plot bout locations 
figure(2); title('PD burst frequency vs. time');
plot(PDts,PDf,'.')
hold on
cntl=bouts(bouts(:,2)==1,:);
plot(PDts(cntl(:,1)),PDf(cntl(:,1)),'cd')
intbts=bouts(bouts(:,2)==2,:);
plot(PDts(intbts(:,1)),PDf(intbts(:,1)),'rd')
bts=bouts(bouts(:,2)==3,:);
plot(PDts(bts(:,1)),PDf(bts(:,1)),'kd')
rec=bouts(bouts(:,2)==4,:);
plot(PDts(rec(:,1)),PDf(rec(:,1)),'gd')

figure(3); title('PD burst frequency vs. phase');
PD.bouts=zeros(length(PD.bstat(:,1)),1); 
PD.bouts(PDindex)=bouts(:,2);
LP.phcat=PD.bouts(LP.phase(LP.phase(:,2)>0,2)+1);

plot(PD.bstat(LP.phase(LP.phcat==1,2)+1,5),LP.phase(LP.phcat==1,1), 'c.')
hold on
plot(PD.bstat(LP.phase(LP.phcat==2,2)+1,5),LP.phase(LP.phcat==2,1), 'r.')
plot(PD.bstat(LP.phase(LP.phcat==3,2)+1,5),LP.phase(LP.phcat==3,1), 'k.')
plot(PD.bstat(LP.phase(LP.phcat==4,2)+1,5),LP.phase(LP.phcat==4,1), 'g.')

end