

% setup
init
clrs = set_colors;

% Load the data
if ~exist('data', 'var')
  sessionKey = 'bac10a';
  bSilent = false;
  data = loadData(sessionKey, bSilent);
  
  % Load labels 
  labelsData = loadLabels(sessionKey, 'merged-yuval')
  labelsData = remove_nans_from_labels_data(labelsData);
  beg_labels_in_sec = labelsData.burstStartTimes;
  
  % Shift begin times that have <=1 spikes
  n_active = times_to_num_active_units(data, estimate_bin_sec);
  
  beg_labels_in_tbin = ceil(beg_labels_in_sec / estimate_bin_sec);
  [beg_labels_in_tbin, beg_labels_in_sec] = align_to_nonzero_beg(n_active, beg_labels_in_sec, ...
					    beg_labels_in_tbin, estimate_bin_sec);
end

[f_list, parms] = take_from_struct(parms, 'f_list', {'n0', 'n-1', ...
		    'n-2', 'n-3', 'n+1', 'n+2', 'n+3' 'd+1', 'd+2', ...
		    'd+3', 'd-1' 'd-2', 'd+3', 's+1', 's-1'});


[features, labels] = build_train_set(n_active, beg_labels_in_tbin, parms);
labels(labels<0) = 0;

method = take_from_struct(parms, 'method', 'lassoglm');
figure(2) ; clf; hold on; 


% Train and Test
if ~exist('best_model', 'var')
  parms.method = 'lasso';
  parms.do_plot = false;
  [best_model, AUC] = train_and_test(features, labels, parms);
end

 % Infer burst start 
if ~exist('S',  'var')
  S = data_to_sparse_mat(data, estimate_bin_sec);
end

burst_peak_times = find_burst_peak(data, labelsData.yesTimes, parms);
[inferred_times, errs] = infer_burst_start(n_active, burst_peak_times, ...
					   best_model, parms, S, ...
					   beg_labels_in_sec);


return

[err] = eval_burst_beg(burst_times, inferred_times); 
 
 

 
 
% Infer bursts and beginings
[all_times, all_scores] = infer_bursts(data, parms);
burst_times = all_times;
[times, scores] = infer_burst_start(data, burst_times, best_model, parms);




