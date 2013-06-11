function [burst_times, pvalues] = detect_bursts(train, parms)
%

  % train is expected to have spike times in seconds

  interval_for_collecting_sec = take_from_struct(parms, 'interval_for_collecting_sec', 60*5);
  interval_for_estimating_sec = take_from_struct(parms, 'interval_for_collecting_sec', 1);


  % compute a vector of spike counts at 'interval..' resolution
  times = sort(cell2mat(trains'));
  times = interval_for_estimating_sec*ceil(times/interval_for_estimating_sec);
  rate = sparse(times, ones(size(times)), ones(size(times)));
  
  num_bins_in_epoch = interval_for_collecting_sec / ...
      interval_for_estimating_sec;
  num_epochs = length(rate) / num_bins_in_epoch;

  bins = [0:1:500];
  pvalues = cell(num_epochs, 1);
  burst_times = cell(num_epochs, 1);
  for i_epoch = 1:num_epochs
    % Estimate the distribution
    p_beg = (i_epoch-1)*num_bins_in_epoch + 1;
    p_end = i_epoch*num_bins_in_epoch;
    pdf = hist(rate(p_beg:p_end), bins);
    cdf = cumsum(pdf) / sum(pdf);

    % Compmute burst-pvalue
    pvalues{i_epoch} = 1-cdf(rate(p_beg:p_end)+1);
    burst_times{i_epoch} = p_beg+find(pvalues<0.01);
  end

end