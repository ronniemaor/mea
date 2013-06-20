function rasterWithBursts(data, parms)
    data = sortUnitsByRate(data);
    nBase = data.nBaselineHours;

    burst_times = detect_bursts(data, parms.burst_mode, parms);
    
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
    strBurstParams = sprintf('%s, bin=%d sec', parms.burst_mode, parms.estimate_bin_sec);    
    switch parms.burst_mode
        case 'gamma_per_bin'
            strMore = sprintf(', pvalue=%.0f%%', 100*parms.significance_threshold);
        case 'gamma_on_base'
            strMore = sprintf(', pvalue=%.0f%%', 100*parms.significance_threshold);
        case 'fraction_active'
            strMore = sprintf(', fraction=%.0f%%', 100*parms.fraction);
    end
    ttl = sprintf('%s - %s%s', strHeading, strBurstParams, strMore);
    ttl = strrep(ttl, '_', '\_');
end