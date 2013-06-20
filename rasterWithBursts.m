function rasterWithBursts(data, parms)
    data = sortUnitsByRate(data);
    nBase = data.nBaselineHours;

    burst_times = detect_bursts(parms.burst_mode, data.unitSpikeTimes, data.nBaselineHours, parms);
    
    plotTimes = [nBase nBase+1, nBase+4, 30];
    nPlots = length(plotTimes);
    
    figure;
    for iPlot=1:nPlots
        subplot(nPlots,1,iPlot)
        plotOneSection(data, burst_times, plotTimes(iPlot));
    end
    topLevelTitle(getTitle(data,parms))
end

function plotOneSection(data, burst_times, hourNum)
    title(sprintf('Hour number %d',hourNum))
    hold on;
    for iUnit = 1:data.nUnits
      times = data.unitSpikeTimes{iUnit};  
      plot(times, iUnit*ones(size(times)), '.')
    end
    plot(burst_times, zeros(size(burst_times)), 'rx', 'MarkerSize', 12, 'LineWidth', 3);
    xlabel('time [s]')
    
    startTime = (hourNum-1) * 20 * 60;
    xrange = 100;
    xlim([startTime startTime + xrange])
end

function ttl = getTitle(data,parms)
    strHeading = sprintf('Raster plot for %s',data.sessionKey);
    strBurstParams = sprintf( ...
        '%s, threshold=%.0f%%, bin=%d sec', ...
        parms.burst_mode, ...
        100*parms.significance_threshold, ...
        parms.estimate_bin_sec ...
    );
    ttl = sprintf('%s - %s', strHeading, strBurstParams);
    ttl = strrep(ttl, '_', '\_');
end