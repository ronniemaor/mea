function labelsData = remove_duplicates_from_labels_data(labelsData)
% Remove duplicate entries in burstStartTimes

  % First sort by start time values 
  [~, inds] = sort(labelsData.burstStartTimes);
  burstStartTimes = labelsData.burstStartTimes(inds);
  burstEndTimes = labelsData.burstEndTimes(inds);  
  yesTimes = labelsData.yesTimes(inds);
 
  % Now remove duplicate start times
  valid_start = [diff(burstStartTimes)./burstStartTimes(1:end-1) > eps true];
  labelsData.burstStartTimes = burstStartTimes(valid_start);
  labelsData.burstEndTimes = burstEndTimes(valid_start);  
  labelsData.yesTimes = yesTimes(valid_start);

  % First sort by end time values 
  [~, inds] = sort(labelsData.burstEndTimes);
  burstStartTimes = labelsData.burstStartTimes(inds);
  burstEndTimes = labelsData.burstEndTimes(inds);  
  yesTimes = labelsData.yesTimes(inds);
 
  % Now remove duplicate end times
  valid_end = [diff(burstEndTimes)./burstEndTimes(1:end-1) > eps true];
  labelsData.burstStartTimes = burstStartTimes(valid_end);
  labelsData.burstEndTimes = burstEndTimes(valid_end);  
  labelsData.yesTimes = yesTimes(valid_end);

  invalids = nnz(~valid_start) + nnz(~valid_end);
  fprintf('\tremoved %d duplicate burstTimes\n', invalids);
end
