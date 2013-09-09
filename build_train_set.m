function [features, labels] = build_train_set(n_active, beg_labels_in_tbin, ...
					       parms)
%
% For every positive time=point, extract various features.
% Also, assume that the nearby are negatives. and extract features
% for them as well.
%

  f_list = take_from_struct(parms, 'f_list');
  
  % Collect features for positive beginings
  pos_features = extract_features(n_active, beg_labels_in_tbin, f_list);
  pos_labels = ones(size(pos_features,1),1);  
  
  % Collect features for negative beginings
  neg_inds = vertcat(beg_labels_in_tbin(:)-1, beg_labels_in_tbin(:)+2);
  neg_features = extract_features(n_active, neg_inds, f_list);
  neg_labels = -ones(size(neg_features,1),1);
  
  features = vertcat(pos_features, neg_features);
  labels = vertcat(pos_labels, neg_labels);  
end
  
