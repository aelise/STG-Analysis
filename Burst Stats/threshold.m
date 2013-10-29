function [spikeindex] = threshold(inputMatrix, thresh, tooBigThresh, timeAfterLastSpike)
%THRESHOLD Script returns the rising threshold crossing indicies IF the
%following two conditions are met
%1. The spike does not go above tooBigThresh
%2. The spike does not occur within timeAfterLastSpike (units: sample number)

%% Find all spikes above thresh
if thresh >= 0
    spikeindex_temp = [0;diff(inputMatrix>=thresh)>0];
else
    spikeindex_temp = [0;diff(inputMatrix<=thresh)>0];
end

%% Plucking out the second crossing if it's too close to the last crossing
spikeindex = find(spikeindex_temp);
ISIs=diff(spikeindex);
todeleteindex=[0; ISIs<=timeAfterLastSpike];

todeleteindex=ISIcheck(todeleteindex);

spikeindex(todeleteindex>0)=[];

%% Find all spikes that are too big 
if tooBigThresh >= 0
    tooBigSpikeIndex_temp = [0;diff(inputMatrix>=tooBigThresh)>0];
else
    tooBigSpikeIndex_temp = [0;diff(inputMatrix<=tooBigThresh)>0];
end

%% Erase very large spikes
tooBigSpikeIndex = find(tooBigSpikeIndex_temp);
spikeindex=my_setdiff(spikeindex,tooBigSpikeIndex,timeAfterLastSpike);

end

