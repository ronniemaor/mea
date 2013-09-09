function features = extract_features(n_active, times, f_list, parms)
% Extract features, centered around each time in "times".
% The features are used to find the start/end times of bursts.
  num_times = length(times);
  num_features = length(f_list);
  features = zeros(num_times, num_features);
  
  times_in_tbin = ceil(times / parms.estimate_bin_sec);

  n0 = n_active(times_in_tbin);
  for i_f = 1:num_features
    f = f_list{i_f};
    switch f
     case 'n+3',   features(:,i_f) = n_active(times_in_tbin+3);
     case 'n+2',   features(:,i_f) = n_active(times_in_tbin+2);
     case 'n+1',   features(:,i_f) = n_active(times_in_tbin+1);
     case 'n0',    features(:,i_f) = n_active(times_in_tbin+0);
     case 'n-1',   features(:,i_f) = n_active(times_in_tbin-1);
     case 'n-2',   features(:,i_f) = n_active(times_in_tbin-2);
     case 'n-3',   features(:,i_f) = n_active(times_in_tbin-3);
    
     case 'd+3',   features(:,i_f) = n0 - n_active(times_in_tbin+3);
     case 'd+2',   features(:,i_f) = n0 - n_active(times_in_tbin+2);
     case 'd+1',   features(:,i_f) = n0 - n_active(times_in_tbin+1);
     case 'd-1',   features(:,i_f) = n0 - n_active(times_in_tbin-1);
     case 'd-2',   features(:,i_f) = n0 - n_active(times_in_tbin-2);
     case 'd-3',   features(:,i_f) = n0 - n_active(times_in_tbin-3);    

     case 's+1',   features(:,i_f) = n0 + n_active(times_in_tbin+1);
     case 's-1',   features(:,i_f) = n0 + n_active(times_in_tbin-1);
            
     otherwise, error('invalid f_list');
    end
  end  
end
