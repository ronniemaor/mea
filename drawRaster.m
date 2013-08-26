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
        [features, featureTimes] = burstFeatures(data, tContextStart, tContextEnd, parms);
        activity = features(:,1);
        posEdge = features(:,2);
        negEdge = features(:,3);

        edges = max(posEdge,negEdge);
        p = take_from_struct(parms,'wEdges',0.65);
        scores = p*edges + (1-p)*activity;        
        plot(featureTimes, 2*data.nUnits*scores, 'b-')
        
%         plot(featureTimes, 2*data.nUnits*activity, 'b-')
%         plot(featureTimes, 2*data.nUnits*posEdge, 'g-')
%         plot(featureTimes, 2*data.nUnits*negEdge, 'r-')
    end
end


