function [scores, times] = score_bursts(data, tStart, tEnd, parms)
%
  p = take_from_struct(parms,'wEdges');
  [features, times] = burstFeatures(data, tStart, tEnd, parms);
  activity = features(:,1);
  posEdges = features(:,2);
  negEdges = features(:,3);
  edges = max(posEdges, negEdges);
  scores = p*edges + (1-p)*activity;	
  
  times = times(:);
end