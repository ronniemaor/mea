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
        plot(scoreTimes, scores(:,1), 'b-') % positive edge
        plot(scoreTimes, scores(:,2), 'r-') % negative edge
        plot(scoreTimes, scores(:,3), 'g-') % activity
    end
end


