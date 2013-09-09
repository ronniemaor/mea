function labelsData = remove_nans_from_labels_data(labelsData)
%
  valids = ~isnan(labelsData.burstStartTimes);
  labelsData.burstStartTimes = labelsData.burstStartTimes(valids);
  labelsData.burstEndTimes = labelsData.burstEndTimes(valids);  
  labelsData.yesTimes = labelsData.yesTimes(valids);
  end
  