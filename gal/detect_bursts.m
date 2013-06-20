function [burst_times, pvalues] = detect_bursts(data, burst_mode, parms)
%
% Detect time of bursts for each cell.
%

  
  switch burst_mode
   case 'gamma_per_bin', 
    [burst_times, pvalues] = detect_bursts_gamma(data, parms, 'per_bin');
   case 'gamma_on_base', 
    [burst_times, pvalues] = detect_bursts_gamma(data, parms, 'on_base');
   case 'fraction_active', 
    [burst_times, pvalues] = detect_bursts_fraction_active(data, parms);
   otherwise , error('invalid burst mode = %s', burst_mode);
  end
  
end  
  

% =======================================================================
function [burst_times, pvalues] = detect_bursts_gamma(data, parms, base_mode)
  % train is expected to have spike times in seconds
  collect_bin_sec = 60*20; % TODO: scale nBaselineHours to allow different sized epochs. # take_from_struct(parms, 'collect_bin_sec', 60*20);
  estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec', 1);
  significance_threshold = take_from_struct(parms, 'significance_threshold');

  % compute a vector of spike counts at 'bin..' resolution
  times = sort(cell2mat(data.unitSpikeTimes'));
  bins = ceil(times/estimate_bin_sec);
  rate = sparse(bins, ones(size(bins)), ones(size(bins))); % total spikes (over units) for each bin
  
  num_bins_in_epoch = floor(collect_bin_sec / estimate_bin_sec);
  if num_bins_in_epoch - floor(num_bins_in_epoch) > eps; error('num_bins_in_epoch must be a whole number'); end; % otherwise our epoch placement below will drift
  num_bins_in_epoch = floor(num_bins_in_epoch);
  num_epochs = floor(length(rate) / num_bins_in_epoch);

  pvalues = cell(num_epochs, 1);
  burst_times = cell(num_epochs, 1);
  base_rates = full(rate(1:data.nBaselineHours*num_bins_in_epoch));
  for i_epoch = 1:num_epochs
    % Estimate the distribution
    p_beg = (i_epoch-1)*num_bins_in_epoch + 1;
    p_end = i_epoch*num_bins_in_epoch;
    rates = full(rate(p_beg:p_end));
    % pdf = hist(rate(p_beg:p_end), bins);
    % cdf = cumsum(pdf) / sum(pdf);

    % Fit a Gamma model to the pdf 
    switch base_mode
        case 'per_bin'
            rates_to_fit = rates;
        case 'on_base'
            rates_to_fit = base_rates;
        otherwise
            error('Invalid base_mode: %s',base_mode)
    end    
    warning('off', 'stats:gamfit:ZerosInData')
    theta_hat = gamfit(rates_to_fit);
    
    % Compmute burst-pvalue
    allpvalues = 1-gamcdf(rates,theta_hat(1), theta_hat(2));
    inds = find(allpvalues < significance_threshold);
    burst_times{i_epoch} = estimate_bin_sec * (p_beg + inds - 1);
    pvalues{i_epoch} = allpvalues(inds);
  end

  % flatten the output
  burst_times = cell2mat(burst_times);
  pvalues = cell2mat(pvalues);
end

% =======================================================================
function [burst_times, pvalues] = detect_bursts_fraction_active(data, parms)
  pvalues = NaN; % not computing pvalues

  % train is expected to have spike times in seconds
  estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec', 1);
  threshold = take_from_struct(parms, 'fraction');

  % compute a vector of spike counts at 'bin..' resolution
  nBins = floor(20*60 * data.networkFullHours / estimate_bin_sec);
  unitActiveBins = zeros(data.nUnits,nBins);
  for iUnit = 1:data.nUnits
      unitTimes = data.unitSpikeTimes{iUnit};
      bins = unique(ceil(unitTimes/estimate_bin_sec));
      unitActiveBins(iUnit,bins) = 1;
  end
  fractionActive = sum(unitActiveBins) / data.nUnits;
  burst_times = estimate_bin_sec * find(fractionActive > threshold);
  burst_times = burst_times';
end