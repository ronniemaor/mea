function r = baseRates(data)
    r = zeros(1,data.nUnits);
    for i = 1:data.nUnits
        times = data.unitSpikeTimes{i};
        r(i) = sum(times < 3600) / 3600;
    end
    hist(r,20)
    title(sprintf('Session %s: mean=%.2f, median=%.2f',data.sessionKey, mean(r),median(r)))
end
