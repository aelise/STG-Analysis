function [stats1 stats2]=calcphasestats(ref, var1, var2)
%Calculates phase relationships
%Assumes each param has the following structure (columns):
%   1 - spike indicies
%   2 - start(1) and stop(-1) indicators for bursts
%Note: bursts of the first param define zero phase
%Function returns the following stats for ea var:
%   1 - phase of var vs. ref (burst on to burst on)
%   2 - start of burst indicies for ref (in corresponding bstats)
%   3 - start of burst indicies for var (in corresponding bstats)

bursts=ref(:,2)>0;
burstind=find(bursts)-1; %bstat indicies (aka ind of spike ind) for start of bursts
switch1=~isempty(var1);
if switch1
    bursts=var1(:,2)>0;
    all_v1ind=find(bursts)-1; %bstat indicies (aka ind of spike ind) for start of bursts
end
switch2=~isempty(var2);
if switch2
    bursts=var2(:,2)>0;
    all_v2ind=find(bursts)-1; %bstat indicies (aka ind of spike ind) for start of bursts
end

n=length(burstind);
stats1=zeros(n,3);
stats2=zeros(n,3);

for i=1:n-1
    %pull out the spike index value for the start of ea local ref burst
    refB1=ref(burstind(i),1);
    refB2=ref(burstind(i+1),1);
    %find any spikes from var1 that fall between the bursts from ref
    if switch1 && ~isempty(all_v1ind)
        %do any var1 bursts start between the two ref bursts?
        v1inds=all_v1ind((var1(all_v1ind,1)>refB1 & var1(all_v1ind,1)<refB2));
        if ~isempty(v1inds) %if so, use the first one
            var1B1=var1(v1inds(1),1); %find the spike index value
            stats1(i,1)=(var1B1-refB1)/(refB2-refB1); %calc phase w/ spike indicies
            stats1(i,2)=burstind(i); %keep bstat ind for later 
            stats1(i,3)=v1inds(1); %keep bstat ind for later 
        end
    end
    
    %do the same for var2
    if switch2 && ~isempty(all_v2ind)
        v2inds=all_v2ind((var2(all_v2ind,1)>refB1 & var2(all_v2ind,1)<refB2));
        if ~isempty(v2inds)
            var2B1=var2(v2inds(1),1); 
            stats2(i,1)=(var2B1-refB1)/(refB2-refB1);
            stats2(i,2)=burstind(i); 
            stats2(i,3)=v2inds(1);
%             stats2(i,2:4)=ref(burstind(i),4:6); 
%             stats2(i,5:7)=var2(v2inds(1),4:6); 
        end
    end
end

stats1(stats1(:,1)==0,:)=[];
stats2(stats2(:,1)==0,:)=[];