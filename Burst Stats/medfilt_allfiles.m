

%get the file directory and the list of files
d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.mat'));
L=length(files);

for filenum=1:L
    %open file
    load(files(filenum).name, 'ans');
    %     ans(:,3)=medfilt1(ans(:,3));
    %     save(files(filenum).name, 'ans')
    
    %[a,s,t] = MAXtlimavg(ans,3,46);
    [a,s,pt] = tlimavg(ans,8,13,3);
    folderdata(filenum).name=files(filenum).name;
    folderdata(filenum).avg=a;
    folderdata(filenum).stddev=s;
    %folderdata(filenum).maxT=t;
end

%code for extracting the data in various forms

chABC={folderdata(3:10).name};
DNchABC={folderdata(1:2).name};
cntrl={folderdata(11:16).name};

chABCavgs=[folderdata(3:10).avg];
DNchABCavgs=[folderdata(1:2).avg];
cntrlavgs=[folderdata(11:16).avg];

chABCstd=[folderdata(3:10).stddev];
cntrlstd=[folderdata(11:16).stddev];
DNchABCstd=[folderdata(1:2).stddev];
% 
% DNchABCmaxT=[folderdata(1:2).maxT];
% cntrlmaxT=[folderdata(11:16).maxT];
% chABCmaxT=[folderdata(3:10).maxT];