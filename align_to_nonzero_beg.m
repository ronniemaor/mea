function   [beg_labels_in_tbin, beg_labels_in_sec] = ...
    align_to_nonzero_beg(n_active, beg_labels_in_sec, beg_labels_in_tbin, ...
			 estimate_bin_sec);
  %
  % TODO(ronnie) describe what the func does
  %
  
  for shift  = 1:5
    early_beg = find(n_active(beg_labels_in_tbin) <= 1);
    beg_labels_in_tbin(early_beg) = beg_labels_in_tbin(early_beg) + 1;
    beg_labels_in_sec(early_beg) = beg_labels_in_sec(early_beg) + estimate_bin_sec;
  end
end

