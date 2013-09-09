function draw_simple(data, tBin_in_sec)
%
  figure(1); clf; hold on;
  
  for iUnit = 1:data.nUnits
    times = data.unitSpikeTimes{iUnit};
    if isempty(times)
      continue
    end 
    plot(times/tBin_in_sec+1, iUnit*ones(size(times)), '.');
  end
  
  % ticks = (0:100:5*10^4);
  % set(gca, 'xtick', ticks);
  % set(gca, 'xticklabels', ceil(ticks/tBin_in_sec))  
  xlabel(sprintf('bin in resolution of %4.2f\n', tBin_in_sec))
  
  
end
  