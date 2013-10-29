%Script to start up a batch analysis of spike/burst detection 
%.mat files to be analyzed will contain matrix "dat" with columnwise data

%% Init
%init global variable 
global LP PD PY

%FilenumBoundaries are for changing parameters mid-analyis. 
%Use empty matrix for no param switches, or a matrix of the format:
%[0 firstSwitchFilenum secondSwitchFilenum max#ofFiles]
%the example would correspond to 3 param sets.
LP.filenumBoundaries=[0 1100 1400];% 
LP.i=1; %for keeping track of which parameter set you're using

%Choosing which files and which channels to analyze
LP.ch_index=[2 1]; %Which channel is LVN? [LVN] or [LVN PDN]  
LP.ch_i=[2 1]; %How many channels for each filenum boundary
PD.case=[0 0]; %Method of detecting PD bursts. 0 = thr only, 1=LP priority, 2=PD priority, 3=K means
LP.datname='dat12';

%Plotting start/stop times
x1=220000;
x2=260000;
plotfreq=15;
%constant
LP.samplesPerSecond=2000;
startfile=1;

params = [x1,x2,startfile, plotfreq];

%% From here- comment out if you don't want to override saved values

%Spike thresholds etc
LP.tooBigTHR=[1 1];
LP.THR =[0.2 0.24];% %use empty vector for visual choice of thresholds
PD.THR =[0.08 0.15]; % ]%
PY.THR =[0.05 0.05]; %

LP.spikeWidth=[30 30];  %Typical 0.015*2000=30
PD.spikeWidth=[16 16];   %Typical 0.002->0.01*2000=4->20
PY.spikeWidth=[6 6];  %Typical 0.005*2000=10

LP.maxISI=[400 400];  %Typical 0.1*2000=200
PD.maxISI=[330 330];  %Typical 0.06
PY.maxISI=[200 200];  %Typical 0.1

LP.minSpikes=[3 3]; %Spikes per burst
PD.minSpikes=[3 3];
PY.minSpikes=[5 5];

%% Init / Preallocation
LP.bstat=zeros(5000000,8); %init
PD.bstat=zeros(5000000,8);
PY.bstat=zeros(5000000,8);

LP.phase=zeros(500000,3);
PD.phase=zeros(500000,3);
PY.phase=zeros(500000,3);

LP.b=1; PD.b=1; PY.b=1;%burststat placeholders for preallocation
LP.p=1; PD.p=1; PY.p=1;%phase placeholders for preallocation


%% Run
burstanalysis(params);