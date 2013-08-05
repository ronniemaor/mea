function unitsToDiscard = findUnstableUnits(data, threshold)
    if ~exist('threshold','var')
        threshold = 0.3;
    end

    units = zeros(1,data.nUnits);
    for iUnit = 1:data.nUnits
        ISIs = calcISIs(data.unitSpikeTimes{iUnit});
        fRate = @(x) 1/mean(x);
        rateStart = fRate(ISIs{1});
        rateEnd = fRate(ISIs{data.nBaselineHours});
        deltaRate = rateEnd-rateStart;
        change = deltaRate/rateStart;
        if abs(change) > threshold
            units(iUnit) = 1;
        end
    end
    unitsToDiscard = find(units);
end
