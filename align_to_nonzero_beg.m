function beg_labels_in_sec = align_to_nonzero_beg(n_active, beg_labels_in_sec, parms)
  %
  % Some labels of burst start times don't make sense because they are in 
  % bins where no units fire, or just one unit fires.
  %
  % We tighten this loose labeling by advancing any burst-beginning labels in parms.estimate_bin_sec
  % increments (one "bin") until they are fall in bins where there are at least 2 active units.
  % 
  % Input:
  %   n_active - Precomputed number of active units in all bins (bins are of size parms.estimate_bin_sec)
  %   beg_labels_in_sec - labels of burst start times in units of seconds
  %
  % Output:
  %   beg_labels_in_sec - corrected labels for burst start times
  %
  beg_labels_in_tbin = ceil(beg_labels_in_sec / parms.estimate_bin_sec);
  for shift  = 1:5
    early_beg = find(n_active(beg_labels_in_tbin) <= 1);
    beg_labels_in_tbin(early_beg) = beg_labels_in_tbin(early_beg) + 1;
    beg_labels_in_sec(early_beg) = beg_labels_in_sec(early_beg) + parms.estimate_bin_sec;
  end
end
