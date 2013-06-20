function [num_active, bin_times] = num_units_active(data, parms)
  estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec', 1);

  % compute a vector of spike counts at 'bin..' resolution
  nBins = floor(20*60 * data.networkFullHours / estimate_bin_sec);
  unitActiveBins = zeros(data.nUnits,nBins);
  for iUnit = 1:data.nUnits
      unitTimes = data.unitSpikeTimes{iUnit};
      bins = unique(ceil(unitTimes/estimate_bin_sec));
      bins = bins(bins <= nBins);
      unitActiveBins(iUnit,bins) = 1;
  end
  num_active = sum(unitActiveBins);
  bin_times = estimate_bin_sec * (1:nBins);
end
