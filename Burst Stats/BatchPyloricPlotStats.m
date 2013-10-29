function [temp]=BatchPyloricPlotStats()
% A function to open all of the burststat files in a folder, and plot / perform
% statistical tests on each. 

%% Get the file directory and the list of files
d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.mat'));

% %% cycle through files - instantaneous phase vs. period
% for filenum=1:length(files) 
%     % open file 
%     load(files(filenum).name);
%    
%     %PyloricPlot();
%     
%     %plot phase vs. period for time subsets
%     figure(filenum)
%    
%     for x=20000:10000:40000%(length(LP.phase)-5001)
%         plot(LP.phase(x:x+4999,1),PD.bstat(LP.phase(x:x+4999,2)+1,5),'.','Color', [rand(1),rand(1),rand(1)]);
%         hold on
%         axis([0 1 0 1]);
%     end
%     title(files(filenum).name);
%     hold off
% %     figure(3)
% %     for x=1000:5000:100000%(length(PY.phase)-5001)
% %         plot(PY.phase(x:x+5000,1),PD.bstat(PY.phase(x:x+5000,2)+1,5),'.','Color', [rand(1),rand(1),rand(1)]);
% %         hold on
% %         axis([0 1 0 1]);
% %     end
% %     hold off
% 
% end


% %% cycle through files - mean phase vs. mean period (~20 min chunks)
% for filenum=1:length(files) 
%     % open file 
%     load(files(filenum).name);
%     
%     %find start-stop times graphically
%     figure(1)
%     len=length(PD.bstat(:,1));
%     if len<1000000
%         plot(1./PD.bstat(1:len,5),'.')
%     else
%         plot(1./PD.bstat(1:1000000,5),'.')
%     end
%     ylim([0 2]);
%     [x,~] = ginput(2);
%     [x1]=find(LP.phase(:,2)>floor(x(1)),1);
%     [x2]=find(LP.phase(:,2)>floor(x(2)),1);
%     
%     %Or just set start-stop time manually?
%     %     x=40000;
%     %     meanphase=mean(LP.phase(x:x+2000,1));
%     %     meanperiod=mean(PD.bstat(LP.phase(x:x+2000,2)+1,5));
%     
%     %% Compute average phase and plot vs. average period    
%     meanphase=mean(LP.phase(x1:x2,1));
%     meanperiod=mean(PD.bstat(LP.phase(x1:x2,2)+1,5));
%     figure(2); hold on;
%     plot(meanperiod,meanphase,'g.');
%     axis([0 3 0 1]);
%     files(filenum).name
%     tfactor=60*60;
%     PD.bstat(LP.phase(x1,2)+1,1)*tfactor
%     PD.bstat(LP.phase(x2,2)+1,1)*tfactor
%     hold off;
% end

% %% INTACT:cycle through files - hr10, hr20, to last stable activity - stats
% temp.slope=zeros(length(files),2); 
% temp.x=zeros(length(files),3);
% temp.y=zeros(length(files),3);
% 
% for filenum=1:length(files) 
%     % open file 
%     load(files(filenum).name);
%     
%     %% init
%     offset=0;
%     tfactor=1;
%     PDindex=PD.bstat(:,3)>0;
%     PDts=PD.bstat(PDindex,1)*tfactor-offset;
%     PDper=PD.bstat(PDindex,5); PDf=1./PDper;
%     PDcolor1=[0.0980,0.4157,0.4510];
%     PDcolor2=[0.6314,0.7490,0.2118];
% 
%     %% find hr20 and last stable activity graphically
%     figure(1)
%     plot(PDts,PDf,'.','markers',5,'Color', PDcolor1)
%     hold on; PDff=medfilt1(PDf,5);
%     plot(PDts,PDff,'.','markers',4,'Color', PDcolor2)
%     hold off
%     ylim([0 3]);
%     [temp.x(filenum, :),temp.y(filenum,:)] = ginput(3);
%     temp.name(filenum)= cellstr(files(filenum).name);
%     
% end
% %% Compute slopes
% temp.slope(:,1)= (temp.y(:,2)-temp.y(:,1))./(temp.x(:,2)-temp.x(:,1));
% temp.slope(:,2)= (temp.y(:,3)-temp.y(:,2))./(temp.x(:,3)-temp.x(:,2));

%% DC: cycle through files - mean phase vs. mean period (~20 min chunks)
for filenum=1:length(files) 
    % open file 
    load(files(filenum).name);
    
    %find start-stop times graphically
    figure(1)
    len=length(PD.bstat(:,1));
    if len<1000000
        plot(1./PD.bstat(1:len,5),'.')
    else
        plot(1./PD.bstat(1:1000000,5),'.')
    end
    ylim([0 2]);
    [x,~] = ginput(2);
    [x1]=find(LP.phase(:,2)>floor(x(1)),1);
    [x2]=find(LP.phase(:,2)>floor(x(2)),1);

    %% Compute average phase and plot vs. average period    
    meanphase=mean(LP.phase(x1:x2,1));
    meanperiod=mean(PD.bstat(LP.phase(x1:x2,2)+1,5));
    figure(2); hold on;
    plot(meanperiod,meanphase,'g.');
    axis([0 3 0 1]);
    files(filenum).name
    tfactor=60*60;
    PD.bstat(LP.phase(x1,2)+1,1)*tfactor
    PD.bstat(LP.phase(x2,2)+1,1)*tfactor
    hold off;
end

end