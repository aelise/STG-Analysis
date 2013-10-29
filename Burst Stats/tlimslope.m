function [s] = tlimslope(ts, dat, start, end_t)

    t=ts(ts>start & ts<end_t);
    temp=medfilt1(dat(ts>start & ts<end_t),100);
    if length(t)>500 %another option: st< some value
        %s=diff(temp)./diff(t);
        %avgS=mean(s(15:length(s)-15));
        s=polyfit(t(15:length(t)-15),temp(15:length(temp)-15), 1);
        s=s(1);
    else
        s=0;
        avgS=0;
    end
end