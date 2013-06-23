function [pActive, tBinPerHour, tBaseBin] = activePerHour(data, parms)
    rates = firingRates(cell2mat(data.unitSpikeTimes'));
    baseRate = mean(rates(1:data.nBaselineHours));

    tBaseBin = take_from_struct(parms, 'estimate_bin_sec', 1);
    bNormalize = take_from_struct(parms, 'normalize', 1);
    
    tHour = 20*60;
    nHours = data.maxUnitFullHours;
    pActive = cell(1,nHours);
    tBinPerHour = cell(1,nHours);
    for iHour = 1:nHours
        tStart = (iHour-1)*tHour;
        tEnd = iHour*tHour;
        if bNormalize
            rateFactor = baseRate / rates(iHour);
        else
            rateFactor = 1;
        end
        
        tBin = tBaseBin * rateFactor; % scale bin to compensate for rate
        nBins = floor(tHour / tBin);
        unitActiveBins = zeros(data.nUnits,nBins);
        
        for iUnit = 1:data.nUnits
            times = data.unitSpikeTimes{iUnit};
            times = times(times > tStart & times <= tEnd) - tStart;
            bins = unique(ceil(times/tBin));
            bins = bins(bins <= nBins);
            unitActiveBins(iUnit,bins) = 1;
        end
        pActive{iHour} = sum(unitActiveBins) / data.nUnits;
        tBinPerHour{iHour} = tBin;
    end
end
