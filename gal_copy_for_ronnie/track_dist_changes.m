function [dkls, rate] = track_dist_changes(isis_array, num_baseline_hours, num_bins)
  baseline_isis = cell2mat(isis_array(1:num_baseline_hours)');
  baseline_rate = 1/mean(baseline_isis);  
  
  % Find edges that make isis{1] uniform
  edges = prctile(baseline_isis, (0:num_bins-1)*100/num_bins);
  edges = unique(round(edges))+0.5;
  
  % compute Dkl w.r.t. to baseline_isis
  base_pdf = get_distribution(baseline_isis, edges);
  if any(base_pdf<eps)
    disp(base_pdf)
    error('Baseline distribution should not contain zeros');
  end
  
  num_sessions = length(isis_array);
  dkls = nan(1,num_sessions);
  pdfs = zeros(length(base_pdf),num_sessions);
  rate = zeros(1,num_sessions);  

  for i=1:length(isis_array)
    isis = isis_array{i};
    rate(i) = 1/mean(isis);
    isis_corrected = isis*rate(i)/baseline_rate;
    if isempty(isis_corrected), isis_corrected = 20*60; end    
    curr_pdf = get_distribution(isis_corrected, edges);
    dkls(i) = calc_Dkl(curr_pdf, base_pdf);
    pdfs(:,i) = curr_pdf(:);
  end
end  

% ==========================================
function Dkl = calc_Dkl(p_pdf, q_pdf)
  inds = p_pdf > eps;
  if isempty(inds), Dkl = NaN; return; end;
  pp_pdf = p_pdf(inds);
  qq_pdf = q_pdf(inds);
  Dkl = sum(pp_pdf .* log2(pp_pdf ./ qq_pdf) );
end
% ==========================================
function curr_pdf = get_distribution(isis, edges)
  n = histc(isis, [-Inf edges Inf]);
  n = n(1:end-1); % remove count of elements that "match Inf"
  curr_pdf = n / sum(n);
  if all(curr_pdf<eps)
    error
  end
  
end


