function [features, labels] = build_train_set(n_active, labels_in_sec, bStart, parms)
%
% For every positive time-point, extract various features.
% Also, assume that the nearby are negatives, and extract features
% for them as well.
%
  f_list = take_from_struct(parms, 'f_list');
  delta = ternary(bStart, 1, -1);
  
  % Collect features for positive beginings
  pos_features = extract_features(n_active, labels_in_sec, f_list, parms);
  pos_labels = ones(size(pos_features,1),1);  
  
  % Collect features for negative beginings
  tBin = parms.estimate_bin_sec;
  neg_inds = vertcat(labels_in_sec(:)-tBin*delta, labels_in_sec(:) ...
		     + 2*tBin*delta);
  neg_features = extract_features(n_active, neg_inds, f_list, parms);
  neg_labels = -ones(size(neg_features,1),1);
  
  features = vertcat(pos_features, neg_features);
  labels = vertcat(pos_labels, neg_labels);  
end
