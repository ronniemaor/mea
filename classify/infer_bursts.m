function [burst_peak_times, burst_peak_scores] = infer_bursts(data, parms)
% Find all burst peak times and "burst peak scores" for those peaks
    threshold = parms.threshold;
   
    tHour = 20*60;
    burst_peak_scores = [];
    burst_peak_times = [];    
    for iHour = 1:data.maxUnitFullHours
        tStart = (iHour-1)*tHour;
        tEnd = iHour*tHour;
        [scores, score_times] = score_bursts(data, tStart, tEnd, parms);
        good_bursts = scores > threshold;
        burst_peak_scores = vertcat(burst_peak_scores, scores(good_bursts));
        burst_peak_times = vertcat(burst_peak_times, score_times(good_bursts));	
    end
end
