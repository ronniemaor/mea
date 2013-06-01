function rasterPlot(data)
    figure;
    hold on;
    for iUnit = 1:data.nUnits
      times = data.unitSpikeTimes{iUnit};  
      plot(times, iUnit*ones(size(times)), '.')
    end
    title(sprintf('Raster plot for %s',data.sessionKey))
end