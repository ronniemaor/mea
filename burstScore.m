function [scores, scoreTimes] = burstScore(data, tStart, tEnd, parms)
    w = take_from_struct(parms, 'estimate_bin_sec', 0.05);
    tBin = w / 2; % we use 50% overlap between the original patterns, so we use half-sized bins that serve for both shifts

    % compute a vector of spike counts at 'bin..' resolution
    nBins = floor((tEnd-tStart) / tBin);
    unitActiveBins = zeros(data.nUnits,nBins);
    for iUnit = 1:data.nUnits
        times = data.unitSpikeTimes{iUnit};
        times = times(times > tStart & times < tEnd) - tStart;
        bins = unique(ceil(times/tBin));
        bins = bins(bins <= nBins);
        unitActiveBins(iUnit,bins) = 1;
    end
    pActive = sum(unitActiveBins) / data.nUnits;
    
    h = 0.5 * [-1 -1 1 1];
    nShift = 2; % number of positions to shift so times align with the beginning of the positive edge of the filter
    scores = abs(conv(pActive',h,'valid'));
    nScores = length(scores);
    scores(:,2) = pActive(1+nShift:1+nShift+nScores-1);
    scoreTimes = tStart + nShift*tBin + tBin*(0:nScores-1);
end
