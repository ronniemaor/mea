function S = data_to_sparse_mat(data, parms)
% Converts the spike times to a sparse matrix of S(#unit,#bin).
% The price we pay is aligning all spike times to bins of parms.estimate_bin_sec
  tBin = parms.estimate_bin_sec;
  times = sort(cell2mat(data.unitSpikeTimes'));
  
  num_units = data.nUnits;
  num_t_bins = ceil(max(times)/tBin);
  S = sparse([], [], [], num_units, num_t_bins, length(times));
  
  for i_unit = 1:num_units
    times_in_tbin = ceil(data.unitSpikeTimes{i_unit}/tBin);
    S(i_unit, times_in_tbin) = 1;
  end
end
