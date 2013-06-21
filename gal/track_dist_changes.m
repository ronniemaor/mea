function [Dkl, rate] = track_dist_changes(isis_array, num_bins);  
  baseline_isis = cell2mat(isis_array(1:3)');
  baseline_rate = 1/mean(baseline_isis);  

  % Find edges that make isis{1] uniform
  edges = prctile(baseline_isis, [1:num_bins-1]*100/num_bins);
  edges = unique(round(edges))+0.5;

  % compute Dkl wrt to isis 1
  base_pdf = get_distribution(baseline_isis, edges);
  if any(base_pdf<eps), error; end

  for i=1:length(isis_array)
    isis = isis_array{i};
    rate(i) = 1/mean(isis);
    isis_corrected = isis*rate(i)/baseline_rate;
    Dkl(i) = calc_Dkl(isis_corrected, edges, base_pdf);
  end

end  

% ==========================================
function Dkl = calc_Dkl(isis, edges, base_pdf)
% The Dkl with a uniform distribution is 
% sum plogp - sum p log(1/N) = -H + log2(N)
  if isempty(isis), Dkl = NaN; return;end;

  pdf = get_distribution(isis, edges);
  inds = pdf > eps;
  pdf = pdf(inds);
  base_pdf = base_pdf(inds);
  Dkl = sum(pdf .* log2(pdf ./ base_pdf) );
end
% ==========================================
function pdf = get_distribution(isis, edges)
  n = histc(isis, [-Inf edges Inf]);
  n = n(1:end-1); % remove count of elements that "match Inf"
  pdf = n / sum(n);
end


