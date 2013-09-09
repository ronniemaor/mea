function [all_times, all_scores] = infer_bursts(data, parms)
% 

  
    threshold = take_from_struct(parms, 'threshold');
    bNormalize = take_from_struct(parms,'bNormalize',true);
   
    tHour = 20*60;
    nHours = data.maxUnitFullHours;
    burstsPerHour = zeros(1,nHours);
    all_scores = [];
    all_times = [];    
    for iHour = 1:nHours
        tStart = (iHour-1)*tHour;
        tEnd = iHour*tHour;
	[scores, score_times] = score_bursts(data, tStart, tEnd, parms);
	good_bursts = scores > threshold;
	all_scores = vertcat(all_scores, scores(good_bursts));
	all_times = vertcat(all_times, score_times(good_bursts));	
    end
end
