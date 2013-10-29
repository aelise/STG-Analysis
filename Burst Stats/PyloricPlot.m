function []=PyloricPlot()
%Plots plots and more plots!
%Inputs have .burststat var which includes:
%   1-time values for each spike (from start of larger experiment)
%   2-indicies of each spike (from the file they are in aka subset of exp) 
%   3-burst start(1) and stop(-1) indicators (note: not always paired @end of files)
%   4-ISIs for spikes within each burst (sec)
%   5-Burst period (sec)
%   6-Burst duration (sec)
%   7-Spikes/burst
%   8-start of new file indicator (1)
%also a .phase var (w/ no zeros):
%   1 - phase of var vs. ref
%   2 - start of burst indicies for ref (in corresponding bstats)
%   3 - start of burst indicies for var (in corresponding bstats)
global LP PD PY

%% Plotting params
LPcolor1=[0.4353,0.1451,0.0941];% 0.3765,0.3569,0.3725];
LPcolor2=[0.7333,0.2902,0.1020];%0.6627,0.0235,0.2549];
PDcolor1=[0.0980,0.4157,0.4510];
PDcolor2=[0.6314,0.7490,0.2118];
PYcolor1=[0.4235,0.4784,0.4078];
PYcolor2=[0.7294,0.6431,0];


%% init
offset=0;
tfactor=1;
LPindex=LP.bstat(:,3)>0; %get burst start indicies, for data retrieval
LPts=LP.bstat(LPindex,1)*tfactor-offset; %get time values 
PDindex=PD.bstat(:,3)>0;
PDts=PD.bstat(PDindex,1)*tfactor-offset;
PYindex=PY.bstat(:,3)>0;
PYts=PY.bstat(PYindex,1)*tfactor-offset;


%% Plot burst period/frequency over time for each cell type
% figure;
LPper=LP.bstat(LPindex,5); 
PDper=PD.bstat(PDindex,5); 
PYper=PY.bstat(PYindex,5); 

subplot(3,1,1); %hold on;
LPt=LPts(LPper>0); LPp=LPper(LPper>0);%remove end-of-file zeros
plot(LPt,LPp,'.','markers',5, 'Color', LPcolor1)  
title('Burst Period'); 
hold on; LPpp=medfilt1(LPp,5);
plot(LPt,LPpp,'.','markers',4, 'Color', LPcolor2)
% [LPa,LPs,LPt]=MINtlimavg(LPt,LPpp,30)
% plot(LPt,LPa,'kx','markers',10)

subplot(3,1,2);
PDt=PDts(PDper>0); PDp=PDper(PDper>0);%remove end-of-file zeros
plot(PDt,PDp,'.','markers',5, 'Color', PDcolor1)
hold on; PDpp=medfilt1(PDp,5);
plot(PDt,PDpp,'.','markers',4,'Color', PDcolor2)
% [PDa_o,PDs_o,PDt_o]=MINtlimavg(PDt,PDpp,1,12)
% [PDa,PDs,PDt]=MINtlimavg(PDt,PDpp,30)
% plot(PDt,PDa,'kx','markers',10)

subplot(3,1,3);
PYt=PYts(PYper>0); PYp=PYper(PYper>0);%remove end-of-file zeros
plot(PYt,PYp,'.','markers',5,'Color', PYcolor1)
hold on; PYpp=medfilt1(PYp,5);
plot(PYt,PYpp,'.','markers',4, 'Color', PYcolor2)

figure;
LPf=1./LPper;
PDf=1./PDper;
PYf=1./PYper;

subplot(3,1,1);  
plot(LPts,LPf,'.','markers',5,'Color', LPcolor1)
title('Burst Frequency');
hold on; LPff=medfilt1(LPf,5);
plot(LPts,LPff,'.','markers',4, 'Color', LPcolor2)
% [LPa,LPs,LPt]=MAXtlimavg(LPts,LPff,30);
% plot(LPt,LPa,'kx','markers',10)

subplot(3,1,2);
plot(PDts,PDf,'.','markers',5, 'Color', PDcolor1)
%initslope=tlimslope(PDts, PDf, 8, 15)
hold on; PDff=medfilt1(PDf,5);
plot(PDts,PDff,'.','markers',4,'Color', PDcolor2)
% [PDa_o,PDs_o,PDt_o]=MAXtlimavg(PDts,PDff,10,12)
% [PDa,PDs,PDt]=MAXtlimavg(PDts,PDff,30)
% plot(PDt,PDa,'kx','markers',10)

subplot(3,1,3);
plot(PYts,PYf,'.','markers',5,'Color', PYcolor1)
hold on; PYff=medfilt1(PYf,5);
plot(PYts,PYff,'.','markers',4, 'Color', PYcolor2)


% %% Plot burst period/frequency of triphasic bursts only (PD burst period)
% [tri_PDind tri_LP tri_PY] =intersect(LP.phase(:,2),PY.phase(:,2));
% tri_PDind=tri_PDind+1;
% tri_LPind=LP.phase(tri_LP,3)+1;
% tri_PYind=PY.phase(tri_PY,3)+1;
% 
% triLPts=LP.bstat(tri_LPind,1); %get time values 
% triPDts=PD.bstat(tri_PDind,1);
% triPYts=PY.bstat(tri_PYind,1);
% 
% % figure;
% LPper=LP.bstat(tri_LPind,5);
% PDper=PD.bstat(tri_PDind,5);
% PYper=PY.bstat(tri_PYind,5);
% % subplot(3,1,1); %hold on;
% % plot(triLPts,LPper,'r.')
% % subplot(3,1,2);
% % plot(triPDts,PDper,'b.')
% % subplot(3,1,3);
% % plot(triPYts,PYper,'g.')
% 
% figure; 
% LPf=1./LPper;
% PDf=1./PDper;
% PYf=1./PYper;
% subplot(3,1,1)
% plot(triLPts,LPf,'.','markers',5,'Color', LPcolor1); 
% title('Burst period: Triphasic')
% hold on; LPf=medfilt1(LPf,5);
% plot(triLPts,LPf,'.','markers',4, 'Color', LPcolor2)
% [triLPa,triLPs,triLPt]=MAXtlimavg(triLPts,LPf,45)
% plot(triLPt,triLPa,'kx','markers',10)
% 
% subplot(3,1,2);
% plot(triPDts,PDf,'.','markers',5,'Color', PDcolor1)
% hold on; PDf=medfilt1(PDf,5);
% plot(triPDts,PDf,'.','markers',4,'Color', PDcolor2)
% [triPDa,triPDs,triPDt]=MAXtlimavg(triPDts,PDf,45)
% plot(triPDt,triPDa,'kx','markers',10)
% 
% subplot(3,1,3);
% plot(triPYts,PYf,'.','markers',5,'Color', PYcolor1)
% hold on; PYf=medfilt1(PYf,5);
% plot(triPYts,PYf,'.','markers',4, 'Color', PYcolor2)
% 

% %% Plot PD burst period vs. phase of LP and PY
% figure; 
% plot(PD.bstat(LP.phase(:,2)+1,5),LP.phase(:,1),'.','Color', LPcolor1) %all
% title('PD burst period vs. phase');
% % %plot(PD.bstat(tri_PDind,5),LP.phase(tri_LP,1),'r.') %triphasic
% % hold on
% % plot(PD.bstat(PY.phase(:,2)+1,5),PY.phase(:,1),'g.') %all 
% % %plot(PD.bstat(tri_PDind,5),PY.phase(tri_PY,1),'g.') %triphasic
% 
% %% Plot spikes/burst for each cell type over time
% figure; 
% subplot(3,1,1)
% LPspb=LP.bstat(LPindex,7);
% plot(LPts,LPspb,'.','markers',5,'Color', LPcolor1)
% title('Spikes per burst');
% subplot(3,1,2)
% PDspb=PD.bstat(PDindex,7);
% plot(PDts,PDspb,'.','markers',5,'Color', PDcolor1)
% subplot(3,1,3)
% PYspb=PY.bstat(PYindex,7);
% plot(PYts,PYspb,'.','markers',5,'Color', PYcolor1)
% 
% %% Plot phase vs. spikes/burst or burst duration?
% 
% %% Duty cycle over time
% figure;
% subplot(3,1,1); 
% LPd=LP.bstat(LPindex,6)./LP.bstat(LPindex,5);
% plot(LPts,LPd,'.','markers',5,'Color', LPcolor1); title('Duty Cycle');
% subplot(3,1,2)
% PDd=PD.bstat(PDindex,6)./PD.bstat(PDindex,5);
% plot(PDts,PDd,'.','markers',5,'Color', PDcolor1)
% subplot(3,1,3)
% PYd=PY.bstat(PYindex,6)./PY.bstat(PYindex,5);
% plot(PYts,PYd,'.','markers',5,'Color', PYcolor1)

end

function [sps,var, g]=subsetstats(dat, ind ,t)

temp=dat(ts>t & ts<(t+5));

end
