function labelsData = remove_nans_from_labels_data(labelsData)
% Remove "yes" labels where start/end times were not marked
  valids = ~isnan(labelsData.burstStartTimes);
  labelsData.burstStartTimes = labelsData.burstStartTimes(valids);
  labelsData.burstEndTimes = labelsData.burstEndTimes(valids);  
  labelsData.yesTimes = labelsData.yesTimes(valids);

  fprintf('\tremoved NaN from burstTimes\n');
end
