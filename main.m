% setup
init
clrs = set_colors;

% Load the data
if ~exist('data', 'var')
  sessionKey = 'bac10a';
  bSilent = false;
  data = loadData(sessionKey, bSilent);
  
  % Load labels 
  labelsData = loadLabels(sessionKey, 'merged-yuval');
  labelsData = remove_nans_from_labels_data(labelsData);
  beg_labels_in_sec = labelsData.burstStartTimes;
  
  % Shift begin times that have <=1 spikes
  n_active = times_to_num_active_units(data, estimate_bin_sec);
  
  beg_labels_in_sec = align_to_nonzero_beg(n_active, beg_labels_in_sec, parms);
end

[f_list, parms] = take_from_struct(parms, 'f_list', {'n0', 'n-1', ...
		    'n-2', 'n-3', 'n+1', 'n+2', 'n+3' 'd+1', 'd+2', ...
		    'd+3', 'd-1' 'd-2', 'd+3', 's+1', 's-1'});

[features, labels] = build_train_set(n_active, beg_labels_in_sec, parms);
labels(labels<0) = 0;

method = take_from_struct(parms, 'method', 'lassoglm');
[do_plot, parms] = take_from_struct(parms, 'do_plot', false);

if do_plot
    figure(2) ; clf; hold on;
end

% Train and Test
if ~exist('best_model', 'var')
  parms.method = 'lasso';
  [best_model, AUC] = train_and_test(features, labels, parms);
  fprintf('Computed model. AUC=%g\n', AUC);
end

 % Infer burst start 
if ~exist('S',  'var')
  S = data_to_sparse_mat(data, parms);
end

burst_peak_times = find_burst_peak(data, labelsData.yesTimes, parms);
[inferred_times, errs] = infer_burst_start(n_active, burst_peak_times, ...
					   best_model, parms, S, ...
					   beg_labels_in_sec);

return % work in progress

err = eval_burst_beg(burst_times, inferred_times); 
 
% Infer bursts and beginings
[burst_peak_times, burst_peak_scores] = infer_bursts(data, parms);
[times, scores] = infer_burst_start(data, burst_peak_times, best_model, parms);

