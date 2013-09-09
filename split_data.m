function [trn_data, tst_data, trn_lbls, tst_lbls] ...
    = split_data(data, lbls, seed, fold)
%
% SPLIT_DATA(DATA, LBLS, SEED, FOLD)
% 

  % CV5  
  n_lines = size(data,1);
  if fold>5 || fold<1 
      error('Illegal fold = %d', fold);
  end
  p = ceil(n_lines/5);
  tst_inds = (1:p) + (fold-1)*p; 
  trn_inds  = [1:min(tst_inds)-1 , max(tst_inds)+1:n_lines];
  trn_inds = trn_inds(trn_inds < n_lines);
  tst_inds = tst_inds(tst_inds < n_lines);
  
  % Randomize
  RANDSTATE = set_rand(seed);
  rrr = randperm(n_lines);
  trn_inds = rrr(trn_inds);
  tst_inds = rrr(tst_inds);  
  
  trn_data = data(trn_inds,:);
  tst_data = data(tst_inds,:);
  trn_lbls = lbls(trn_inds);
  tst_lbls = lbls(tst_inds);
  
  set_rand(RANDSTATE);
end
