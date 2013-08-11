function drawRaster(hAxes, data, tStart, parms)
    tEnd = tStart + parms.T;
    dt = parms.contextSize * parms.T;
    tContextStart = tStart - dt;
    tContextEnd = tEnd + dt;
    
    tX = take_from_struct(parms,'tX',10);
    if tContextEnd - tContextStart > tX
        xmin = tContextStart;
        xmax = tContextEnd;
    else
        xMid = (tContextStart + tContextEnd)/2;
        xmin = xMid - tX/2;
        xmax = xMid + tX/2;
    end    

    axes(hAxes);
    cla;
    colorActive = [1 0 0.2];
    colorInactive = 0.8*[1 1 1];
    for iUnit = 1:data.nUnits
        times = data.unitSpikeTimes{iUnit};
        times = times(times > tContextStart & times <= tContextEnd);
        plot(times, iUnit*ones(size(times)), '.', 'color', colorInactive)
        hold on;
        times = times(times > tStart & times <= tEnd);
        plot(times, iUnit*ones(size(times)), '.', 'color', colorActive)
        xlim([xmin xmax])
        ylim([0 data.nUnits+1])
    end
    set(hAxes, 'FontSize', 16)
    xlabel('t [sec]')
    ylabel('unit number')
    
    bDrawScore = take_from_struct(parms,'bDrawScore',false);
    if bDrawScore
        [scores, scoreTimes] = burstScore(data, tContextStart, tContextEnd, parms);
        scores = scores * data.nUnits;
        plot(scoreTimes, scores(:,1), 'b-') % derivative
        plot(scoreTimes, scores(:,2), 'g-') % pActive
    end
end

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
    
    h = [-0.5 -0.5 0.5 0.5];
    nShift = 2; % number of positions to shift so times align with the beginning of the positive edge of the filter
    scores = abs(conv(pActive',h,'valid'));
    nScores = length(scores);
    scores(:,2) = pActive(1+nShift:1+nShift+nScores-1);
    scoreTimes = tStart + nShift*tBin + tBin*(0:nScores-1);
end
