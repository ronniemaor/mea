function features = extract_features(n_active, times, f_list, parms)
% Extract features, centered around each time in "times".
% The features are used to find the start/end times of bursts.
  num_times = length(times);
  num_features = length(f_list);
  features = zeros(num_times, num_features);
  
  times_in_tbin = ceil((times+0.0000001) / parms.estimate_bin_sec);

  %if length(unique(times_in_tbin)) ~= length(times_in_tbin)
  %  length(unique(times_in_tbin)) 
  %  length(times_in_tbin)
  %  length(times)
  %  length(unique(times))
  %  error('\n\n\t\tError: duplicates in extract features %s\n\n', '');
  %end
  
  
  n0 = n_active(times_in_tbin);
  np1 = n_active(times_in_tbin+1);
  np2 = n_active(times_in_tbin+2);
  np3 = n_active(times_in_tbin+3);
  np4 = n_active(times_in_tbin+4);
  np5 = n_active(times_in_tbin+5);
  np6 = n_active(times_in_tbin+6);
  
  nm1 = n_active(times_in_tbin-1);
  nm2 = n_active(times_in_tbin-2);
  nm3 = n_active(times_in_tbin-3);
  nm4 = n_active(times_in_tbin-4);
  nm5 = n_active(times_in_tbin-5);
  nm6 = n_active(times_in_tbin-6);  

  for i_f = 1:num_features
    f = f_list{i_f};
    switch f
     case 'n+3',   features(:,i_f) = np3;
     case 'n+2',   features(:,i_f) = np2;
     case 'n+1',   features(:,i_f) = np1;
     case 'n0',    features(:,i_f) = n0;
     case 'n-1',   features(:,i_f) = nm1;
     case 'n-2',   features(:,i_f) = nm2;
     case 'n-3',   features(:,i_f) = nm3;
    
     case 'r+3',   features(:,i_f) = 1 - np3./n0;
     case 'r+2',   features(:,i_f) = 1 - np2./n0;
     case 'r+1',   features(:,i_f) = 1 - np1./n0;
     case 'r-1',   features(:,i_f) = 1 - nm1./n0;
     case 'r-2',   features(:,i_f) = 1 - nm2./n0;
     case 'r-3',   features(:,i_f) = 1 - nm3./n0;

     case 'd+3',   features(:,i_f) = n0 - np3;
     case 'd+2',   features(:,i_f) = n0 - np2;
     case 'd+1',   features(:,i_f) = n0 - np1;
     case 'd-1',   features(:,i_f) = n0 - nm1;
     case 'd-2',   features(:,i_f) = n0 - nm2;
     case 'd-3',   features(:,i_f) = n0 - nm3;

     case 's+1',   features(:,i_f) = n0 + np1;
     case 's-1',   features(:,i_f) = n0 + nm2;
     case 's+2',   features(:,i_f) = n0 + np1 + np2;
     case 's-2',   features(:,i_f) = n0 + nm2 + nm2;
     case 's+3',   features(:,i_f) = n0 + np1 + np2 + np3;
     case 's-3',   features(:,i_f) = n0 + nm2 + nm2 + nm3;

     case 's+4',   features(:,i_f) = n0 + np1 + np2 + np3 + np4;
     case 's-4',   features(:,i_f) = n0 + nm2 + nm2 + nm3 - np4;
      
     case 's+5',   features(:,i_f) = n0 + np1 + np2 + np3 + np4 + np5;
     case 's-5',   features(:,i_f) = n0 + nm2 + nm2 + nm3 - np4 - np5; 
      
     case 's+6',   features(:,i_f) = n0 + np1 + np2 + np3 + np4 + np5 + np6;
     case 's-6',   features(:,i_f) = n0 + nm2 + nm2 + nm3 - np4 - np5 - np6;
      
     otherwise, error('invalid f_list');
    end
  end  
end
