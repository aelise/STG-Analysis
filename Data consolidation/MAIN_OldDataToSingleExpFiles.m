fileprefix='chABC110727_';
startTime=0;
channels=[4 5];

startfile=1;
stopfile=510;

ExtractDataSubset(fileprefix,startTime,channels);
%ExtractDataSubset(fileprefix,startTime,channels,startfile);
%ExtractDataSubset(fileprefix,startTime,channels,startfile,stopfile);