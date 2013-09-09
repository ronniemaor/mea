function labels_in_sec = tighten_burst_start_end_labels(n_active, labels_in_sec, bStart, parms)
  %
  % Some labels of burst start/end times don't make sense because they are in 
  % bins where no units fire, or just one unit fires.
  %
  % We tighten this loose labeling by moving any burst-beginning labels in parms.estimate_bin_sec
  % increments (one "bin") until they are fall in bins where there are at least 2 active units.
  % Start labels are tightened by moving them forward and end labels by moving them backward.
  % 
  % Input:
  %   n_active - Precomputed number of active units in all bins (bins are of size parms.estimate_bin_sec)
  %   beg_labels_in_sec - labels of burst start times in units of seconds
  %
  % Output:
  %   beg_labels_in_sec - corrected labels for burst start times
  %
  delta = ternary(bStart,1,-1);
  
  labels_in_tbin = ceil(labels_in_sec / parms.estimate_bin_sec);
  for shift  = 1:5
    loose_labels = find(n_active(labels_in_tbin) <= 1);
    labels_in_tbin(loose_labels) = labels_in_tbin(loose_labels) + delta;
    labels_in_sec(loose_labels) = labels_in_sec(loose_labels) + delta*parms.estimate_bin_sec;
  end
end
