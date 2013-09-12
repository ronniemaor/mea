function [inferred_times, errs, valids] = infer_burst_edge(n_active, ...
						  burst_peak_times, ...
						  best_model, parms, ...
						  S, labels_in_sec, bStart)
  
  % Given a set of burst-peak times, find for each one of the them
  % a burst-start time. that obeys the following: 
  % 1. It is within the window [-2sec] before the peak
  % 2. It is in the last "contig" of indices that exceed the
  %    threshold ??////???
  
  burst_width_std = take_from_struct(parms, 'burst_width_std', 0.5);  
  max_burst_width = take_from_struct(parms, 'max_burst_width', 0.35);
  estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec');  
  f_list = take_from_struct(parms, 'f_list');
  method = take_from_struct(parms, 'method');  

  valids = ~isnan(burst_peak_times);
  valid_burst_peak_times = burst_peak_times(valids);
  labeled_times = labels_in_sec(valids);
  
  num_bursts = length(valid_burst_peak_times);
  errs = zeros(num_bursts,1);
  inferred_times = zeros(num_bursts,1);
  for i_burst = 1:num_bursts
    peak_time = valid_burst_peak_times(i_burst);

    if bStart
        candidate_edge_times = peak_time-max_burst_width : ...
	    estimate_bin_sec : peak_time+0.1*estimate_bin_sec;
    else
        candidate_edge_times = peak_time-1*estimate_bin_sec : ...
	    estimate_bin_sec : peak_time+max_burst_width;
    end       

    [scores, score_times] = score_bursts(data, candidate_edge_times(1), ...
					 candidate_edge_times(end), parms);
    
    

    candidate_edge_times_forplot = peak_time-2 : estimate_bin_sec : peak_time+2;        
    
    % Preprocess
    features = extract_features(n_active, candidate_edge_times, f_list, parms);
    tst_scores = test_model(method, features, best_model);    
    burst_shape = exp(- (candidate_edge_times-peak_time).^2 / burst_width_std);    
    shaped_scores = tst_scores .* burst_shape(:);
    [~, ind] = max(shaped_scores);
    inferred_times(i_burst) = (ind-1)*estimate_bin_sec + min(candidate_edge_times);
    errs(i_burst) = abs(inferred_times(i_burst) - labeled_times(i_burst));

    do_plot = take_from_struct(parms, 'do_plot', true);
    if do_plot
      figure(2) ; clf; hold on;
      
      % Background spikes 
      candidate_start_times_forplot_in_tbin = ceil(candidate_edge_times_forplot / estimate_bin_sec);
      [i,j] = find (S(:, candidate_start_times_forplot_in_tbin(1):candidate_start_times_forplot_in_tbin(end)));
      plot((j-1)*estimate_bin_sec + min(candidate_edge_times_forplot), ...
	   i, '.', 'color', 'k');
      
      % Spikes considered to be in burst
      candidate_start_times_in_tbin = ceil(candidate_edge_times / estimate_bin_sec);
      [i,j] = find (S(:, candidate_start_times_in_tbin(1):candidate_start_times_in_tbin(end)));
      plot((j-1)*estimate_bin_sec + min(candidate_edge_times), i, ...
	   's', 'MarkerSize', 4);
      
      h(1) = plot(candidate_edge_times, tst_scores*40, 'Color', 'k', ...
		  'Linewidth', 3);
      h(5) = plot(candidate_edge_times, shaped_scores*40, 'Color', [0.5 0.5 0.99], ...
		  'Linewidth', 3);
      h(2) = plot(peak_time*[1 1], [0 32], 'Color', 'r');
      h(3) = plot(labeled_times(i_burst)*[1 1], [0 31], 'Color', 'g');	  
      h(4) = plot(inferred_times(i_burst)*[1 1], [-20 31], 'Color', ...
		  'm', 'LineWidth',2);
      legend(h,{'edge scores', 'peak time', 'label', 'inferred', ...
		'shaped'}, 'Location', 'NorthEastOutside')
      input(sprintf('burst = %d, press enter', i_burst));    
    end
  end
  
end