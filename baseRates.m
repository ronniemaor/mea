function r = baseRates(data)
    r = zeros(1,data.nUnits);
    for i = 1:data.nUnits
        times = data.unitSpikeTimes{i};
        r(i) = sum(times < 3600) / 3600;
    end
    [f,x]=hist(r,20);
    p = f/sum(f);
    bar(x,p)
    xlabel('base rate [Hz]')
    ylabel('P(r)')
    title(sprintf('%s: mean=%.2f, median=%.2f',data.sessionKey, mean(r),median(r)))
end
