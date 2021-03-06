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
  labelsData = remove_duplicates_from_labels_data(labelsData);

  % Shift begin times that have <=1 spikes
  n_active = times_to_num_active_units(data, parms, estimate_bin_sec);
  
  beg_labels_in_sec = tighten_burst_start_end_labels(n_active, ...
						  labelsData ...
						  .burstStartTimes, ...
						  true, parms);
  end_labels_in_sec = tighten_burst_start_end_labels(n_active, ...
						  labelsData.burstEndTimes, ...
						  false, parms);
end

[f_list, parms] = take_from_struct(parms, 'f_list', { ...
    'r+1', 'r+2', 'r-1', 'r-2', ...
    'n0' , 'n-1', 'n-2', 'n+1', 'n+2' ...    
}); 

%    's+1', 's+3', 's+5', ...
%    's-1', 's-3', 's-5', ...

%     'd+1', 'd+2', 'd-1', 'd-2', ...    

[do_plot, parms] = take_from_struct(parms, 'do_plot', false);

if do_plot
    figure(2) ; clf; hold on;
end

% Train and Test
if ~exist('beg_best_model', 'var')
  [beg_features, beg_labels] = build_train_set(n_active, beg_labels_in_sec, true, parms);
  [beg_best_model, beg_AUC] = train_and_test(beg_features, beg_labels, parms);
  fprintf('Computed model for burst beginnings. AUC=%g\n', beg_AUC);
end
if ~exist('end_best_model', 'var')
  [end_features, end_labels] = build_train_set(n_active, end_labels_in_sec, false, parms);
  [end_best_model, end_AUC] = train_and_test(end_features, end_labels, parms);
  fprintf('Computed model for burst endings. AUC=%g\n', end_AUC);
end

 % Infer burst start 
if ~exist('S',  'var')
  S = data_to_sparse_mat(data, parms);
end

burst_peak_times = find_burst_peak(data, labelsData.yesTimes, parms);
if ~exist('beg_inferred_times', 'var')
  [beg_inferred_times, beg_errs, beg_valids] = infer_burst_edge(n_active, ...
						  burst_peak_times, ...
						  beg_best_model, ...
						  parms, S, ...
						  beg_labels_in_sec, ...
						  true, data);
  fprintf('Burst begining abs median error = %g sec\n', median((beg_errs)));
end
[end_inferred_times, end_errs, end_valids] = infer_burst_edge(n_active, ...
						  burst_peak_times, ...
						  end_best_model, ...
						  parms, S, ...
						  end_labels_in_sec, ...
						  false, data, beg_inferred_times);
fprintf('Burst ending abs median error = %g sec\n', median(abs(end_errs)));

durations = end_labels_in_sec - beg_labels_in_sec;
inferred_durations = end_inferred_times - beg_inferred_times;
duration_errors = durations(end_valids)'-inferred_durations;
relative_end_errors = median(abs(end_errs)' ./ durations(end_valids));
relative_duration_errors = median(abs(duration_errors)' ./ durations(end_valids));

% fprintf('Burst duration median abs error = %5.3f sec\n', median(abs(duration_errors)));
fprintf('Relative end error = %5.3f (ratio)\n', relative_end_errors);
% fprintf('Relative abs duration error = %5.3f (ratio)\n', relative_duration_errors);






