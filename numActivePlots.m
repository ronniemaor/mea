function numActivePlots(data, parms)
    if nargin<2; parms = make_parms(); end
    nBase = data.nBaselineHours;

    [pActive,~,tBaseBin] = activePerHour(data, parms);
    
    plotTimes = [nBase nBase+1, nBase+4, 46];
    nPlots = length(plotTimes);
    
    figure;
    for iPlot=1:nPlots
        subplot(nPlots,1,iPlot)
        hourNum = plotTimes(iPlot);
        plotOneSection(pActive{hourNum}, tBaseBin, hourNum);
    end
    topLevelTitle(getTitle(data,tBaseBin))
end

function plotOneSection(pActive, tBin, hourNum)
    title(sprintf('Hour number %d',hourNum))
    hold on;

    bin_times = (1:length(pActive))*tBin;
    plot(bin_times, pActive);    
    ylim([0 1])
    xlabel('time [s]')
    ylabel('fraction active')
end

function ttl = getTitle(data,tBaseBin)
    strHeading = sprintf('Number of active units for %s',data.sessionKey);
    strParams = sprintf('bin=%.1f sec', tBaseBin);
    ttl = sprintf('%s - %s', strHeading, strParams);
    ttl = strrep(ttl, '_', '\_');
end