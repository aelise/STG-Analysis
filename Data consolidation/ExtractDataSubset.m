function [] = ExtractDataSubset(fileprefix,startTime,channels,startfile,stopfile)
%A function to grab a subset of columns from a matlab file of the format:
%   column 1 = time in seconds
%   all other columns = voltage values from nerve recordings over time
%Converts time to hours and names the files according to fileprefix
%High-pass filters data
%Will use all files in the specified folder if startfile/stopfile are not
%included. 
%StartTime will offset all time vectors saved, units in hours. 
%Channels is a linear array of indicies, indicating the column numbers to be extracted. 

%get the file directory and the list of files
d = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(d, '*.mat'));

%check for startfile/stopfile
if nargin <4
    startfile=1;
    stopfile=length(files);
    filecount=1309;
elseif nargin==4
    stopfile=length(files);
    filecount=1100+startfile;
else
    filecount=1100;
end

for filenum=startfile:stopfile
    
    %open file
    load(files(filenum).name, 'dat');
    
    %rename outdated naming format
%     dat=ans;
%     clear('ans')
    
    %update time column sec->hrs
    ts=(dat(:,1)/(60*60));
    
    %grab the right channels
    dat=dat(:,channels);
    
    %high-pass filter the data
    for f=1:length(channels)
        dat(:,f)=HighPassFilter(dat(:,f)); 
    end
    
    %drop the first second of data to remove any init artifact 
    dat=dat(2000:length(ts),:);
    ts=ts(2000:length(ts));
    
    %save
    fnam = [fileprefix int2str(filecount)];
    save(fnam , 'ts','dat')
    filecount=filecount+1;
    
    clear dat ts
end


end
