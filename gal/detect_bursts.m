function [burst_times, pvalues] = detect_bursts(burst_mode, trains, parms)
%
% Detect time of bursts for each cell.
%

  
  switch burst_mode
   case 'gamma', 
    [burst_times, pvalues] = detect_bursts_gamma(burst_mode, trains, parms);
   case 'marom', 
    [burst_times, pvalues] = detect_bursts_marom(burst_mode, trains, parms);
   otherwise , error('invalid burst mode = %s', burst_mode);
  end
  
end  
  

% =======================================================================
function [burst_times, pvalues] = detect_bursts_gamma(burst_mode, trains, parms)
  % train is expected to have spike times in seconds
  collect_bin_sec = take_from_struct(parms, 'collect_bin_sec', 60*5);
  estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec', 1);

  % compute a vector of spike counts at 'bin..' resolution
  times = sort(cell2mat(trains'));
  times = estimate_bin_sec*ceil(times/estimate_bin_sec);
  rate = sparse(times, ones(size(times)), ones(size(times)));
  
  num_bins_in_epoch = collect_bin_sec / estimate_bin_sec;
  num_epochs = length(rate) / num_bins_in_epoch;

  bins = [0:1:500];
  pvalues = cell(num_epochs, 1);
  burst_times = cell(num_epochs, 1);
  for i_epoch = 1:num_epochs
    % Estimate the distribution
    p_beg = (i_epoch-1)*num_bins_in_epoch + 1;
    p_end = i_epoch*num_bins_in_epoch;
    rates = full(rate(p_beg:p_end));
    % pdf = hist(rate(p_beg:p_end), bins);
    % cdf = cumsum(pdf) / sum(pdf);

    % Fit a Gamma model to the pdf 
    theta_hat = gamfit(rates);
    
    % Compmute burst-pvalue
    allpvalues = 1-gamcdf(rates,theta_hat(1), theta_hat(2));
    inds = find(allpvalues<0.01);
    burst_times{i_epoch} = p_beg + inds - 1;
    pvalues{i_epoch} = allpvalues(inds);
  end

  % flatten the output
  burst_times = cell2mat(burst_times);
  pvalues = cell2mat(pvalues);
end