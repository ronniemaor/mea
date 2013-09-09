function features = extract_features(n_active, beg_labels_in_tbin, f_list)
%
  num_labels = length(beg_labels_in_tbin);
  num_features = length(f_list);
  features = zeros(num_labels, num_features);
  n0 = n_active(beg_labels_in_tbin+0);
  for i_f = 1:num_features
    f = f_list{i_f};
    switch f
     case 'n+3',   features(:,i_f) = n_active(beg_labels_in_tbin+3);
     case 'n+2',   features(:,i_f) = n_active(beg_labels_in_tbin+2);
     case 'n+1',   features(:,i_f) = n_active(beg_labels_in_tbin+1);
     case 'n0',    features(:,i_f) = n_active(beg_labels_in_tbin+0);
     case 'n-1',   features(:,i_f) = n_active(beg_labels_in_tbin-1);
     case 'n-2',   features(:,i_f) = n_active(beg_labels_in_tbin-2);
     case 'n-3',   features(:,i_f) = n_active(beg_labels_in_tbin-3);
    
     case 'd+3',   features(:,i_f) = n0-n_active(beg_labels_in_tbin+3);
     case 'd+2',   features(:,i_f) = n0-n_active(beg_labels_in_tbin+2);
     case 'd+1',   features(:,i_f) = n0-n_active(beg_labels_in_tbin+1);
     case 'd-1',   features(:,i_f) = n0-n_active(beg_labels_in_tbin-1);
     case 'd-2',   features(:,i_f) = n0-n_active(beg_labels_in_tbin-2);
     case 'd-3',   features(:,i_f) = n0-n_active(beg_labels_in_tbin-3);    

     case 's+1',   features(:,i_f) = n0+n_active(beg_labels_in_tbin+1);
     case 's-1',   features(:,i_f) = n0+n_active(beg_labels_in_tbin-1);
            
     otherwise, error('invalid f_list');
    end
  end  
end