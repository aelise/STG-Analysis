function [h] = snapshotPlot(x1,x2,ts,LPchan,PDchan,LPbstat,PDbstat,PYbstat)

%Declare global vars
global LP PD PY

h=figure(1);
subplot(3,1,1), plot(ts(x1:x2),LPchan(x1:x2));  hold on;
if ~isempty(LPbstat)
    LPspikeindex=LPbstat(:,1);
    temp=LPspikeindex(LPspikeindex>x1 & LPspikeindex<x2);
    if ~isempty(temp)
        plot(ts(temp), LP.THR(LP.i),'.r')
    end
    if ~isempty(LPbstat)
        LPburstindex=[0; LPspikeindex].*[LPbstat(:,2)>0; 0];
        temp=LPburstindex(LPburstindex>x1 & LPburstindex<x2);
        if ~isempty(temp)
            plot(ts(temp), LP.THR(LP.i),'kd')
        end
        
        LPburstindex2=[0; LPspikeindex].*[LPbstat(:,2)<0; 0];
        temp=LPburstindex2(LPburstindex2>x1 & LPburstindex2<x2);
        if ~isempty(temp)
            plot(ts(temp), LP.THR(LP.i),'k^')
        end
    end
end
hold off

subplot(3,1,2), plot(ts(x1:x2),PDchan(x1:x2));  hold on;
if ~isempty(PDbstat)
    PDspikeindex=PDbstat(:,1);
    temp=PDspikeindex(PDspikeindex>x1 & PDspikeindex<x2);
    if ~isempty(temp)
        plot(ts(temp), PD.THR(LP.i),'.r')
    end
    if ~isempty(PDbstat)
        PDburstindex=[0; PDspikeindex].*[PDbstat(:,2)>0; 0];
        temp=PDburstindex(PDburstindex>x1 & PDburstindex<x2);
        if ~isempty(temp)
            plot(ts(temp), PD.THR(LP.i),'kd')
        end
        
        PDburstindex2=[0; PDspikeindex].*[PDbstat(:,2)<0; 0];
        temp=PDburstindex2(PDburstindex2>x1 & PDburstindex2<x2);
        if ~isempty(temp)
            plot(ts(temp), PD.THR(LP.i),'k^')
        end
    end
end
hold off

subplot(3,1,3), plot(ts(x1:x2),LPchan(x1:x2));  hold on;
if ~isempty(PYbstat)
    PYspikeindex=PYbstat(:,1);
    temp=PYspikeindex(PYspikeindex>x1 & PYspikeindex<x2);
    if ~isempty(temp)
        plot(ts(temp), PY.THR(LP.i),'.r')
    end
    if ~isempty(PYbstat)
        PYburstindex=[0; PYspikeindex].*[PYbstat(:,2)>0; 0];
        temp=PYburstindex(PYburstindex>x1 & PYburstindex<x2);
        if ~isempty(temp)
            plot(ts(temp), PY.THR(LP.i),'kd')
        end
        
        PYburstindex2=[0; PYspikeindex].*[PYbstat(:,2)<0; 0];
        temp=PYburstindex2(PYburstindex2>x1 & PYburstindex2<x2);
        if ~isempty(temp)
            plot(ts(temp), PY.THR(LP.i),'k^')
        end
    end
end
hold off


   