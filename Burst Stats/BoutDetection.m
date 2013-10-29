function []=BoutDetection()

global PD

%% init
PDindex=PD.bstat(:,3)>0; %burst start indicies
PDper=PD.bstat(PDindex,5); PDf=1./PDper;
PDts=PD.bstat(PDindex,1);

inbout=0; % indicator for continous bout
bouts=zeros(length(PDindex),3); % bout indicies 

%% find start-stop times graphically (units: burst indicies in PDper)
figure(1)
plot(PDf,'.')
ylim([0 2]);
[x,~] = ginput(2);
[x1]=x(1);
[x2]=x(2);

%% Loop: check for bout, still in bout?, increment, repeat 
w=100;   PDff=medfilt1(PDf,3);
for n=ceil(x1)+w:ceil(x2)-15
    %check window (~10 minutes?)
%     timecheck=PDts(n,1)-PDts(n-w,1);
%     while timecheck<0.1667
%         w=w+50;
%         timecheck=PDts(n,1)-PDts(n-w,1);
%     end
%     while timecheck>0.1667
%         w=w-50;
%         timecheck=PDts(n,1)-PDts(n-w,1);
%     end
%     
%     if w<50
%         w=50;
%     end

    %check for bout
 
    boutcheck=mean(PDff(n-w:n));
    if PDff(n:n+10)>(boutcheck+boutcheck*.4)
        if inbout==0
            inbout=1;
            bouts(n,:)=[n PDts(n) PDf(n)];
        end
    else
        inbout=0;
    end
    
end

%% Plot bout locations 
bts=bouts(bouts(:,1)>0,:);
hold on
plot(bts(:,1),bts(:,3),'rx')

end