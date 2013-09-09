function burst_times = find_burst_peak(data, yes_times, parms)
  % Given a set of T-sec intervals (marked as containing burst),
  % find in each one of them, a 0.5*T-sec-long that obeys the
  % following: 
  % 1. It is above the burst-detection threshold
  % 2. It is in the first "contig" of indices that exceed the
  %    threshold
  % 3. within that contig, it has the maximal value 
  % 
  % If no min-segment exceeds the threshold, the burst peak is
  % assigned a NaN.
    
  threshold = take_from_struct(parms, 'threshold');
  T = take_from_struct(parms, 'T');
  margin = 1;
  
  num_bursts = length(yes_times);
  burst_times = zeros(1,num_bursts);
  for i_burst = 1:num_bursts
    tStart = yes_times(i_burst); % TODO(ronnie) explain why
    tEnd = tStart + T; % in Seconds
    [scores, score_times] = score_bursts(data, tStart-margin, tEnd+margin, parms);
    % plot(score_times, scores);
    
    window = (score_times >= tStart & score_times <= tEnd);
    
    scores_w = scores(window);
    score_times_w = score_times(window);    

    % Find the first contig
    contig_beg =  find(scores_w > threshold,1, 'first');
    contig_end =  find(diff(scores_w > threshold) == -1 , 1, 'first');
    
    if isempty((contig_beg:contig_end))
      burst_times(i_burst) = NaN;
    else
      [~, temp_ind] = max(scores_w(contig_beg:contig_end));
      ind = temp_ind + contig_beg -1;    
      burst_times(i_burst) = score_times_w(ind);
    end    
  end
end
