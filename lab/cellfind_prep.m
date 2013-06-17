function [lengths,hashtable]=cellfind_prep(strs)
%
% CELLFIND_PREP: 
%   prepare auxiliary variables for fast cellfind operation
% 
% Usage: 
%   [LENGTHS,HASHTABLE]=CELLFIND_PREP(STRS)
% 
%   INDS=CELLFIND(CELLARRAY,STR,LENGTHS,HASHTABLE)
%
% Inputs: 
%   STRS - a cell array to be searchd in
% 
% Outputs: 
%   LENGTHS   - vector of lengths of words in c
%   HASHTABLE - vector of hash values of words in c
%  
% Gal Chechik (C) 2004
% 

n_strs = length(strs);
lengths   = zeros(n_strs,1);

if(iscell(strs))
  for i=1:n_strs
    lengths(i) = length(strs{i});
  end
  hashtable = hash(strs);  
else
  % cell arrary was converted to string matrix since all strs had
  % the same length
  
  lengths(1:end) = size(strs,2);
  hashtable = hash(strs);
  
end

return
  
  
  
