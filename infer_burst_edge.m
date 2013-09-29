function [inferred_times, errs, valids] = infer_burst_edge(n_active, ...
                                                      burst_peak_times, ...
                                                      best_model, ...
                                                      parms, S, ...
                                                      labels_in_sec, ...
                                                      bStart, data, ...
                                                      beg_inferred_times)
  
  % Given a set of burst-peak times, find for each one of the them
  % a burst-start time. that obeys the following: 
  % 1. It is within the window [-2sec] before the peak
  % 2. It is in the last "contig" of indices that exceed the
  %    threshold ??////???
  
    
  burst_width_std = take_from_struct(parms, 'burst_width_std', 0.4);
  max_burst_width = take_from_struct(parms, 'max_burst_width', 0.5);
  estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec');  
  f_list = take_from_struct(parms, 'f_list');
  method = take_from_struct(parms, 'method');  
  dd = estimate_bin_sec;
  bHaveLabels = ~isnan(labels_in_sec);
  
  valids = ~isnan(burst_peak_times);
  valid_burst_peak_times = burst_peak_times(valids);
  if bHaveLabels
    labeled_times = labels_in_sec(valids);
  end
  
  num_bursts = length(valid_burst_peak_times);
  errs = zeros(num_bursts,1);
  inferred_times = zeros(num_bursts,1);
  for i_burst = 1:num_bursts
    peak_time = valid_burst_peak_times(i_burst);
    candidate_edge_times_forplot = (peak_time-0.6):dd:(peak_time+1.6); 

    if bStart
      candidate_edge_times = peak_time-max_burst_width : dd : ...
	  peak_time + 0.1*dd;
    else
      candidate_edge_times = peak_time-1*dd : dd : peak_time+max_burst_width;
    end
    
    % Preprocess
    features = extract_features(n_active, candidate_edge_times, f_list, parms);
    tst_scores = test_model(method, features, best_model);
    burst_shape = exp(- (candidate_edge_times-peak_time).^2 / burst_width_std);
    shaped_scores = tst_scores;
    offset = 0.1; 
    shaped_scores = (shaped_scores + offset) .* burst_shape(:) - offset;

        
    % Zero scores after a gap between bursts.
    candidate_edge_times2 = peak_time-1*dd : dd : peak_time + 2*max_burst_width;    
    [dense_burst_scores, dense_score_times] = score_bursts(data, ...
						  candidate_edge_times(1)-10*dd, ...
						  candidate_edge_times(end) + 10*dd, parms);
    burst_scores = nan(size(candidate_edge_times));
    for i=1:length(candidate_edge_times)
      iii = find(abs(candidate_edge_times(i) - dense_score_times)< 10^-7);
      burst_times(i) = candidate_edge_times(i);
      burst_scores(i) = dense_burst_scores(iii);
    end
    gap_ind = -1 + find(burst_scores(1:end-1)==0 & burst_scores(2:end)==0, ...
                        1, 'first');
    if ~isempty(gap_ind) && gap_ind>0
        shaped_scores(gap_ind:end) = -1/2;
    end

    [~, ind] = max(shaped_scores);
    inferred_times(i_burst) = (ind-1)*dd + min(candidate_edge_times);
    if exist('beg_inferred_times', 'var') & inferred_times(i_burst) ...            
            < beg_inferred_times(i_burst) + 2 * dd;
%         fprintf('shift end = %4.2f from beg = %4.2f i_burst=%d\n', ...
%                 inferred_times(i_burst), beg_inferred_times(i_burst), i_burst);
        inferred_times(i_burst) = beg_inferred_times(i_burst) + 2*dd;
    end

    if bHaveLabels
        errs(i_burst) = abs(inferred_times(i_burst) - labeled_times(i_burst));
    end
        
    do_plot = take_from_struct(parms, 'do_plot', true);
    if do_plot && ~bStart && bHaveLabels
      LW = 'Linewidth';
      CLR = 'Color';
      clr1 = [0.5 0.5 0.99];
      clr2 = [0.99 0.5 0.5];      
      figure(2) ; clf; hold on;
      title(sprintf('burst = %d, err=%4.2f', i_burst, errs(i_burst)));
      
      % Background spikes 
      candidate_start_times_forplot_in_tbin = ...
	  ceil(candidate_edge_times_forplot / dd);
      [i,j] = find (S(:, candidate_start_times_forplot_in_tbin(1): ...
		      candidate_start_times_forplot_in_tbin(end)));
      hh(1) = plot((j-1)*dd + min(candidate_edge_times_forplot), ...
		   i, '.', 'color', 'k');
      
      % Spikes considered to be in burst
      candidate_start_times_in_tbin = ceil(candidate_edge_times / dd);
      [i,j] = find (S(:, candidate_start_times_in_tbin(1): ...
		      candidate_start_times_in_tbin(end)));
      hh(2) = plot((j-1)*dd + min(candidate_edge_times), i, 's', 'MarkerSize', 4);

      % Scores etc      
      h(1) = plot(candidate_edge_times, tst_scores*40, CLR, 'k', LW, 3);
      h(2) = plot(peak_time*[1 1], [30 40], CLR, 'r');
      h(3) = plot(labeled_times(i_burst)*[1 1], [0 31], CLR, 'g');
      h(4) = plot(inferred_times(i_burst)*[1 1], [-20 31], CLR, 'm', LW, 2);
      h(5) = plot(candidate_edge_times, shaped_scores*40, CLR, clr1, LW, 3);
      h(6) = plot(candidate_edge_times, burst_scores*40, 'o-', CLR, clr2, LW, 3);
      hl = legend(h,{'tst scores', 'peak time', 'human label', 'inferred', ...
		     'shaped scores', 'burst-score'}, 'Location', 'NE');
      set(hl, 'box', 'off');
      ax = axis; ax(2) = ax(2) + 2;
      ax(3) = -20; ax(4) = 40; axis(ax);
      
      do_save = take_from_struct(parms, 'do_save', false);      
      if do_save
          fig_filename = sprintf('Figures/burst-end-estimate-%d', i_burst);
          fig_save(fig_filename, 1, {'png'});
      end
      % input(sprintf('burst = %d, press enter', i_burst));
    end
  end
  
end