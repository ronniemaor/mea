function [scores, times] = score_bursts(data, tStart, tEnd, parms)
% One score_bursts to rule them all (once I remove all the others)
% TODO: any code that calls burstFeatures should actually be changed
% to call this function instead.
  
  p = take_from_struct(parms, 'wEdges');
  [features, times] = burstFeatures(data, tStart, tEnd, parms);
  activity = features(:,1);
  posEdges = features(:,2);
  negEdges = features(:,3);
  edges = max(posEdges, negEdges);
  scores = p * edges + (1-p) * activity;	
  
  times = times(:);
end