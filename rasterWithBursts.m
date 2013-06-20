function rasterWithBursts(data, parms)
    data = sortUnitsByRate(data);

    burst_times = detect_bursts(parms.burst_mode, data.unitSpikeTimes, data.nBaselineHours, parms);
    
    figure;
    title(getTitle(data,parms))
    hold on;
    for iUnit = 1:data.nUnits
      times = data.unitSpikeTimes{iUnit};  
      plot(times, iUnit*ones(size(times)), '.')
    end
    plot(burst_times, zeros(size(burst_times)), 'rx', 'MarkerSize', 12, 'LineWidth', 3);
    xlabel('time [s]')
    
    if isfield(parms,'xrange')
        xlim(parms.xrange)
    end    
end

function ttl = getTitle(data,parms)
    strHeading = sprintf('Raster plot for %s',data.sessionKey);
    strBurstParams = sprintf( ...
        '%s, threshold=%.0f%%, bin=%d sec', ...
        parms.burst_mode, ...
        100*parms.significance_threshold, ...
        parms.estimate_bin_sec ...
    );
    ttl = sprintf('%s\n%s', strHeading, strBurstParams);
    ttl = strrep(ttl, '_', '\_');
end