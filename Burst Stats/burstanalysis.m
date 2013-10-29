function [] = burstanalysis(params)
%Ask the user for the folder to be analyzed
%Ask the user for the spike threshold for each channel in a .mat file
%Compute spike times and burst statistics
%Plot the spike times and burst start/stop times and save a sample tiff

%% Declare global vars
global LP PD PY

%% Get the file directory and the list of files
d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.mat'));
    
%% Unpack params
%plotting start and stop points. Units in sample number.
x1=params(1);
x2=params(2); 
%if you want to skip a certain number of files in the folder
startfile=params(3);
%how often you want a preview plot
plotfreq=params(4);

%% Init spike thresholds, if needed
if isempty(LP.THR)
    [spikeTHR] = getspikeTHR(x1,x2,files(startfile).name,LP.ch_index,LP.datname);
    LP.tooBigTHR=spikeTHR(1);
    LP.THR=spikeTHR(2);
    PD.THR=spikeTHR(3);
    PY.THR=spikeTHR(4);
end

%% Find spikes and bursts for each file in the folder
for filenum=startfile:length(files) %for all files in the folder after startfile
    
    %open file and grab the data you want
    tic
    load(files(filenum).name, LP.datname,'ts');
    if ~strcmp(LP.datname ,'dat')
        eval(['dat=' LP.datname '; clear ' LP.datname ';']);
    end
    ts=ts/(60*60);
    toc
    
    %check filenum, and change params # if needed   
    if ~isempty(LP.filenumBoundaries)
        %parse filename
        dash = findstr('_',files(filenum).name);
        dot = findstr('.',files(filenum).name);
        numstr=files(filenum).name(dash+1:dot-1);
        numnum=str2num(numstr);
        %figure out which filenum boundaries this file is between
        temp=find(LP.filenumBoundaries>numnum,1);
        LP.i=temp-1;
        clear dash dot numstr numnum temp
    end
    
    %find spikes, bursts, and plot these markers over snapshot data
    tic
    
    %% Assign the appropriate data relevant names
    LPchan= -dat(:,LP.ch_index(1));
    if LP.ch_i(LP.i)==2
        PDchan= dat(:,LP.ch_index(2));
    else
        PDchan= LPchan;
    end
    
    %% Find spikes using (1) thresholds (2) ISI values and (3) spike subtraction

    %% Get spikes
    PDspikeindex = threshold(PDchan, PD.THR(LP.i), LP.tooBigTHR(LP.i), PD.spikeWidth(LP.i));
    LPspikeindex = threshold(LPchan, LP.THR(LP.i), LP.tooBigTHR(LP.i), LP.spikeWidth(LP.i));
    PYspikeindex = threshold(LPchan, PY.THR(LP.i), LP.THR(LP.i)/2, PY.spikeWidth(LP.i));
    
    %% Get LP/PD bursts, depending on available nerve recordings
    [PDbstat, LPbstat, PYbstat]=deal([]);
    if LP.ch_i(LP.i)==2 %if both LVN and PDN
        if ~isempty(PDspikeindex)
            [PDbstat]=new_calcburststats(PDspikeindex,PD.minSpikes(LP.i),PD.maxISI(LP.i));
        end
        if~isempty(PDbstat)%remove spikes from index not part of the burst
            PDspikeindex((PDbstat(:,2)+PDbstat(:,3))==0)=[];
        else
            PDspikeindex=[];
        end
        % Update LP spikes by subtracting PD bursts
        LPspikeindex=my_setdiff(LPspikeindex,(PDspikeindex-(0.017*LP.samplesPerSecond)),(2*PD.spikeWidth(LP.i)));
        % Get LP bursts
        if ~isempty(LPspikeindex)
            [LPbstat]=new_calcburststats(LPspikeindex,LP.minSpikes(LP.i),LP.maxISI(LP.i));
            if~isempty(LPbstat)
                LPspikeindex((LPbstat(:,2)+LPbstat(:,3))==0)=[];
            else
                LPspikeindex=[];
            end
        end
        
    else %LVN only
        if ~isempty(LPspikeindex)%add PD.case>0 if you want to use avgISI to separate bursts
            [LPbstat]=new_calcburststats(LPspikeindex,LP.minSpikes(LP.i),LP.maxISI(LP.i),PD.case(LP.i));
        end
        if~isempty(LPbstat)%remove spikes from index not part of the burst
            LPspikeindex((LPbstat(:,2)+LPbstat(:,3))==0)=[];
        else
            LPspikeindex=[];
        end
        % Update PD spikes by subtracting LP bursts
        PDspikeindex=my_setdiff(PDspikeindex,LPspikeindex,(2*PD.spikeWidth(LP.i)));
        % Get LP bursts
        if ~isempty(PDspikeindex)
            [PDbstat]=new_calcburststats(PDspikeindex,PD.minSpikes(LP.i),PD.maxISI(LP.i));
            if~isempty(PDbstat)
                PDspikeindex((PDbstat(:,2)+PDbstat(:,3))==0)=[];
            else
                PDspikeindex=[];
            end
        end
        
    end
    
    
    %% Get PY bursts  
    % Subtract the spikes that are a part of PD/LP bursts from PY spikes
    if LP.ch_i(LP.i)==2 % PDN and LVN both used, and there is a delay b/w channels
        PYspikeindex=my_setdiff(PYspikeindex,(PDspikeindex-(0.017*LP.samplesPerSecond)),LP.spikeWidth(LP.i));
        PYspikeindex=my_setdiff(PYspikeindex, LPspikeindex, LP.spikeWidth(LP.i));   
    else  % LVN only, no PDN, so no delay needed
        PYspikeindex=my_setdiff(PYspikeindex, PDspikeindex, LP.spikeWidth(LP.i));
        PYspikeindex=my_setdiff(PYspikeindex, LPspikeindex, LP.spikeWidth(LP.i));
    end
    
    % Get PY bursts
    if isempty(PYspikeindex)
        PYbstat=[];
    else
        [PYbstat]=new_calcburststats(PYspikeindex,PY.minSpikes(LP.i),PY.maxISI(LP.i));

    end
 
    %% Update running variables 
    if~isempty(PDbstat)
        %add time values to bstat, and update running var
        PDL=PD.b+length(PDbstat(:,1))-1;
        if PDL>length(PD.bstat(:,1)) %check that preallocation is sufficient
            PD.bstat=[PD.bstat; zeros(1000000,8)];
        end
        PD.bstat(PD.b:PDL,:)=[ts(PDbstat(:,1)) PDbstat];
        PD.b=PDL;
    end
    
    if~isempty(LPbstat)
        LPL=LP.b+length(LPbstat(:,1))-1;
        if LPL>length(LP.bstat(:,1))
            LP.bstat=[LP.bstat; zeros(1000000,8)];
        end
        LP.bstat(LP.b:LPL,:)=[ts(LPbstat(:,1)) LPbstat];
        LP.b=LPL;
    end
    
    if~isempty(PYbstat)
        PYL=PY.b+length(PYbstat(:,1))-1;
        if PYL>length(PY.bstat(:,1))
            PY.bstat=[PY.bstat; zeros(1000000,8)];
        end
        PY.bstat(PY.b:PYL,:)=[ts(PYbstat(:,1)) PYbstat];
        PY.b=PYL;
    end
    
     
    %% Calculate phase relationships
    if ~isempty(PDbstat)
        [LPphase PYphase]=calcphasestats(PDbstat, LPbstat, PYbstat);
        if ~isempty(LPphase)
            %adjust indicies to account for multiple files
            LPphase(:,2)=LPphase(:,2)+(PDL-length(PDbstat(:,1)));
            LPphase(:,3)=LPphase(:,3)+(LPL-length(LPbstat(:,1)));           
            LPL=LP.p+length(LPphase(:,1))-1;
            if LPL>length(LP.phase(:,1))
                LP.phase=[LP.phase; zeros(200000,3)];
            end
            LP.phase(LP.p:LPL,:)=LPphase;
            LP.p=LPL;       
        end
        if ~isempty(PYphase)
            PYphase(:,2)=PYphase(:,2)+(PDL-length(PDbstat(:,1)));
            PYphase(:,3)=PYphase(:,3)+(PYL-length(PYbstat(:,1)));
            PY.phase=[PY.phase; PYphase];
            PYL=PY.p+length(PYphase(:,1))-1;
            if PYL>length(PY.phase(:,1))
                PY.phase=[PY.phase; zeros(200000,3)];
            end
            PY.phase(PY.p:PYL,:)=PYphase;
            PY.p=PYL;
        end
    end
  toc
    %% Plot every so often
    if rem(filenum,plotfreq)==0 || filenum==1
        h=snapshotPlot(x1,x2,ts,LPchan,PDchan,LPbstat,PDbstat,PYbstat);
        % Save a tiff/.fig of current figure
        print('-dtiff', '-r300', [files(filenum).name '.tiff']);
        saveas(h,[files(filenum).name '.fig']);
    end
    
    %% Clean up    
    clear LPbstat PDbstat PYbstat LPphase PDphase PYphase

end

% catch
% % %save
% %     save('crashedrename.mat', 'main_bstat*','spikeTHR','minormax')
% %     rethrow(lasterror)
% end

%% Save global variables
save('folder_burstanalysis', 'LP', 'PD', 'PY')
end
