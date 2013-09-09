function draw_simple(data, parms)
% Simple function to draw the raster plot. Consider unifying with drawRaster
% Currently used only for debugging. Time until this comment becomes untrue: 3, 2, 1...
  tBin = parms.estimate_bin_sec;

  figure(1); clf; hold on;
  
  for iUnit = 1:data.nUnits
    times = data.unitSpikeTimes{iUnit};
    if isempty(times)
      continue
    end 
    plot(times/tBin+1, iUnit*ones(size(times)), '.');
  end
  
  % ticks = (0:100:5*10^4);
  % set(gca, 'xtick', ticks);
  % set(gca, 'xticklabels', ceil(ticks/tBin_in_sec))  
  xlabel(sprintf('bin in resolution of %4.2f\n', tBin))
end
