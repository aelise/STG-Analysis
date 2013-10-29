function [fullBurststats]=new_calcburststats(spikeindex,minNumOfSpikes,maxISI,PDcase)
% Burst detection -
%   spikeindex - indicies of spike events
%   minNumOfSpikes - minimum number of spikes/burst
%   maxISI - maximum number of samples between spikes within a burst
%   avgISI - optional, will throw out bursts with avg ISI > this value
% Return relevant stats about resulting bursts, in two forms:
%   fullBurststats=[burstEdges; inBurstISIs; burstPer_wZeros; burstDur_wZeros; numMaxinBurst_wZeros]';
%   abridgedBurststats=[burstPer; burstDur; numMaxinBurst]';

%% Setup
global LP

%whoopsie - recode this someday...
spikeindex=spikeindex';

% Calculate the ISIs for every spike, units in sample number
ISIs=diff(spikeindex);
% Identify ISIs that may be part of a burst (1) and those that aren't (0)
inBurstSpikes=[0 ISIs<=maxISI];
% Identify first spike in burst (1) and last spike in burst (-1)
burstEdges=[0 diff(inBurstSpikes)];

if length(burstEdges(burstEdges>0))>2
    
    burstStartInd=find(burstEdges==1); %Find first spike of burst
    burstEndInd=burstEdges==-1; %Find last spike of burst
    
    %% Calculate spikes per burst
    temp=cumsum(inBurstSpikes); %add up all the inburstspikes
    temp=temp(burstEndInd); %grab only the ones at the end of ea burst
    numMaxinBurst=[temp(1) diff(temp)]; %calculate spikes per burst
    numMaxinBurst=numMaxinBurst+1; %compensate for working with IBIs not spikes
    temp=zeros(1,length(burstEdges));
    temp(burstStartInd(1:length(numMaxinBurst)))=numMaxinBurst;
    numMaxinBurst_wZeros=temp; %plug back in to extended matrix
    
    %% Remove bursts with too few spikes
    tempind=find(numMaxinBurst_wZeros>0 & numMaxinBurst_wZeros<minNumOfSpikes);
    burstEdges(tempind+numMaxinBurst_wZeros(tempind)-1)=0;
    burstEdges(tempind)=0;
    burstStartInd=find(burstEdges==1); %recalculate
    burstEndInd=burstEdges==-1; %recalculate
    inBurstSpikes=cumsum(burstEdges); %recalculate
    numMaxinBurst_wZeros=numMaxinBurst_wZeros.*(numMaxinBurst_wZeros>=minNumOfSpikes);
      
    if length(burstEdges(burstEdges>0))>2
        %% Calculate burst duration
        inBurstISIs=[0 ISIs].*inBurstSpikes;
        temp=cumsum(inBurstISIs); % add up all the ISIs for each burst
        temp=temp(burstEndInd); %grab the totals at the end of ea burst
        ind=find(temp); %get rid of all the zeros
        burstDur=[temp(ind(1)) diff(temp(ind))]; %calculate burstDur from totals
        temp=zeros(1,length(burstEdges));
        temp(burstStartInd(1:length(burstDur)))=burstDur;
        burstDur_wZeros=temp; %plug back in to extended matrix
        
        %% Remove LP bursts when (1) no PDN and (2) looking for PD bursts
        if nargin>3 && PDcase>0
            aISIs=burstDur_wZeros./(numMaxinBurst_wZeros-1);
            burstStdDev=subsetstddev(burstEdges,numMaxinBurst_wZeros,aISIs,inBurstISIs);

            switch PDcase
                case 1 %%Find LP bursts (large avg ISI AND small std dev) 
                    avgISI=mean(aISIs(aISIs>0)); %use mean ISI for this file?
                    avgStdDev=mean(burstStdDev(burstStdDev>0)); %use mean StdDev for this file?
%                     figure(2); plot(aISIs,burstStdDev,'.'); hold on;
%                     plot(avgISI,avgStdDev,'dg'); hold off;
                    tempind=find(aISIs>avgISI & burstStdDev<avgStdDev);
                case 2%%OR find all bursts that are not PD (low avg ISI, high stddev)
                    avgISI=mean(aISIs(aISIs>0)); %use mean ISI for this file?
                    avgStdDev=mean(burstStdDev(burstStdDev>0)); %use mean StdDev for this file?
%                     figure(2); plot(aISIs,burstStdDev,'.'); hold on;
%                     plot(avgISI,avgStdDev,'dg'); hold off;
                    tempind=union(find(aISIs>avgISI),find(burstStdDev<avgStdDev & burstStdDev>0));
                otherwise %%OR use k-means clustering
                    tempAVG=aISIs(aISIs>0)';
                    tempSTD=burstStdDev(burstStdDev>0)';
                    [IDX, C]= kmeans([tempAVG tempSTD],3);
                    figure(3); plot(tempAVG(IDX==1),tempSTD(IDX==1),'.'); hold on;
                    plot(tempAVG(IDX==2),tempSTD(IDX==2),'.r');
                    plot(tempAVG(IDX==3),tempSTD(IDX==3),'.g'); hold off;
                    [~, I]=min(C(:,1));
                    tempAVG(IDX==I)=0;
                    temp=zeros(1,length(burstEdges));
                    temp(burstStartInd(1:length(tempAVG)))=tempAVG;
                    tempind=find(temp>0);
            end

            burstEdges(tempind+numMaxinBurst_wZeros(tempind)-1)=0;
            burstEdges(tempind)=0;
            burstStartInd=find(burstEdges==1); %recalculate
            inBurstSpikes=cumsum(burstEdges); %recalculate
            inBurstISIs=[0 ISIs].*inBurstSpikes; %recalculate
            temp=zeros(1,length(burstEdges));
            temp(burstStartInd)=numMaxinBurst_wZeros(burstStartInd); %grab subset
            numMaxinBurst_wZeros=temp; %plug back in to extended matrix
            temp=zeros(1,length(burstEdges));
            temp(burstStartInd)=burstDur_wZeros(burstStartInd); %grab subset
            burstDur_wZeros=temp; %plug back in to extended matrix
        end
        
        %% Calculate burst period
        burstPer=diff(spikeindex(burstStartInd-1)); %Calc time b/w burst starts
        temp=zeros(1,length(burstEdges));
        temp(burstStartInd)=[burstPer 0];
        burstPer_wZeros=temp; %Plug back into extended matrix
        
        %% Collect gathered info before returning
        temp=zeros(1,length(spikeindex)); %add reference point for file separation in bstat file
        temp(1,1)=1; 
        fullBurststats=[spikeindex; burstEdges; inBurstISIs; burstPer_wZeros; burstDur_wZeros; numMaxinBurst_wZeros; temp]';
        fullBurststats(:,3:5)=fullBurststats(:,3:5)/LP.samplesPerSecond;
        %abridgedBurststats=[burstPer; burstDur; numMaxinBurst]';
    else
        fullBurststats=[];
        %abridgedBurststats=[];
    end
else
    fullBurststats=[];
    %abridgedBurststats=[];
end
end

function [burstStdDev]=subsetstddev(burstEdges,numMaxinBurst_wZeros,aISIs,inBurstISIs)   
    aISIs(isnan(aISIs))=0;

    burstStartInd=burstEdges==1; %recalculate
    burstEndInd=burstEdges==-1; %recalculate

    x=-aISIs(burstStartInd); %positive aISI at start of ea burst
    aISIs(burstEndInd)=x(1:length(aISIs(burstEndInd))); %negative aISI at end of ea burst
    ISIavgs=cumsum(aISIs);
    
    %calc std dev
    temp=(inBurstISIs-ISIavgs).^2; %(ea value - mean value for that burst)^2
    temp=cumsum(temp); %add em all up  
    temp=temp(burstEndInd);%grab the ones at the end of ea burst
    temp=[temp(1) diff(temp)];%compute the difference (i.e. burst-specific values)
    z=zeros(1,length(burstEdges));
    burstStartInd=find(burstEdges==1);
    z(burstStartInd(1:length(temp)))=temp; %plug back in to extended matrix 

    variance=z./(numMaxinBurst_wZeros-2); %calc variance for ea burst
    burstStdDev=variance.^0.5; %std dev for ea burst
    
end
