function [features, featureTimes] = burstFeatures(data, tStart, tEnd, parms)
    w = take_from_struct(parms, 'estimate_bin_sec');
    tBin = w / 2; % we use 50% overlap between the original patterns, so we use half-sized bins that serve for both shifts

    % compute a vector of spike counts at 'bin..' resolution
    nBins = floor((tEnd-tStart) / tBin);
    totalActiveBins = zeros(1,nBins);
    for iUnit = 1:data.nUnits
        singleUnitActiveBins = zeros(1,nBins);
        times = data.unitSpikeTimes{iUnit};
        times = times(times > tStart & times < tEnd) - tStart;
        bins = unique(ceil(times/tBin));
        bins = bins(bins <= nBins);
        singleUnitActiveBins(bins) = 1;
        totalActiveBins = totalActiveBins + singleUnitActiveBins;
    end
    pActive = totalActiveBins / data.nUnits;
    
    derivative = conv(pActive',0.5 * [1 1 -1 -1],'valid');
    activity = conv(pActive',0.5 * [1 1],'valid');
    nScores = length(derivative) - 2; % we lose two positions due to mis-alignment between times of positive and negative edges
    featureTimes = tStart + 3*tBin + tBin*(0:nScores-1);    
    positiveEdgeDiff = derivative(1:end-2); % positive edge centered around each score time
    negativeEdgeDiff = -derivative(3:end); % negative edge centered around each score time
    activity = activity(3:3+nScores-1); % sum of activity around score time
    
    features = [activity, positiveEdgeDiff, negativeEdgeDiff];
end
