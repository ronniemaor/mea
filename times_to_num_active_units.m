function n_active = times_to_num_active_units(data, tBin, tStart, tEnd)
% Calculate number of active units in each bin of length tBin, between 
% the times tStart and tEnd (which default to all times covered by the data)
  if ~exist('tStart', 'var')
    tStart = 0;
  end
  if ~exist('tEnd', 'var')
    tHour = 20*60;
    tEnd = tHour * data.maxUnitFullHours;      
  end

  nBins = floor((tEnd-tStart) / tBin);
  unitActiveBins = zeros(data.nUnits,nBins);
  for iUnit = 1:data.nUnits
    times = data.unitSpikeTimes{iUnit};
    times = times(times > tStart & times < tEnd) - tStart;
    bins = unique(ceil(times/tBin));
    bins = bins(bins <= nBins);
    unitActiveBins(iUnit,bins) = 1;
  end
  n_active = sum(unitActiveBins, 1);
end
