function S = data_to_sparse_mat(data, tBin_in_sec)
%

  times = sort(cell2mat(data.unitSpikeTimes'));
  
  num_units = data.nUnits;
  num_t_bins = ceil(max(times)/tBin_in_sec);
  S = sparse([], [], [], num_units, num_t_bins, length(times));
  
  for i_unit = 1:num_units
    times_in_tbin = ceil(data.unitSpikeTimes{i_unit}/ tBin_in_sec);
    S(i_unit, times_in_tbin) = 1;
  end
end
  