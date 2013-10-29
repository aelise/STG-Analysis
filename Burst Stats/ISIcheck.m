function [todeleteindex]=ISIcheck(todeleteindex)

tempind=0;
burstEdges=[0; diff(todeleteindex)];

while ~isempty(tempind) && length(burstEdges(burstEdges>0))>1
    burstEdges=[0; diff(todeleteindex)]; %identify runs of spikes close together
    burstStartInd=find(burstEdges==1); %Find first spike of "burst"
    burstEndInd=burstEdges==-1; %Find last spike of burst
    
    %% Calculate spikes per burst
    temp=cumsum(todeleteindex); %add up all the inburstspikes
    temp=temp(burstEndInd); %grab only the ones at the end of ea burst
    numMaxinBurst=[temp(1); diff(temp)]; %calculate spikes per burst
    temp=zeros(length(burstEdges),1);
    temp(burstStartInd(1:length(numMaxinBurst)))=numMaxinBurst;
    numMaxinBurst_wZeros=temp; %plug back in to extended matrix
    
    %% Give the third spike of each burst a pass...
    tempind=find(numMaxinBurst_wZeros>4);
    if ~isempty(tempind)
        %remove spikes from the "to delete" index
        todeleteindex(tempind+2)=0;
    end
    
end

