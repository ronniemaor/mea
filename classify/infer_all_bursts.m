function [beg_times, end_times] = infer_all_bursts(data,parms)
    tHour = 20*60;
    tStart = 0;
    tEnd = data.maxUnitFullHours * tHour;
    
    % find peaks
    [scores,times] = score_bursts(data,tStart,tEnd,parms);
    peak_times = times(scores > parms.threshold);
    
    % infer start/end from peaks
    models = load(getBurstEdgeModelsFilename());
    parms.f_list = models.f_list;
    n_active = times_to_num_active_units(data, parms, parms.estimate_bin_sec);
    S = data_to_sparse_mat(data, parms);
    raw_beg_times = infer_burst_edge(n_active, peak_times, models.beg_model, parms, S, NaN, true, data);
    raw_end_times = infer_burst_edge(n_active, peak_times, models.end_model, parms, S, NaN, false, data, raw_beg_times);
    
    % remove overlapping bursts
    lastEnd = -1;
    for i=1:length(raw_beg_times)
        if raw_beg_times(i) > lastEnd
            assert(raw_end_times(i) > raw_beg_times(i))
            lastEnd = raw_end_times(i);
        else
            raw_beg_times(i) = NaN;
            raw_end_times(i) = NaN;
        end
    end
    beg_times = raw_beg_times(~isnan(raw_beg_times));
    end_times = raw_end_times(~isnan(raw_end_times));
    %fprintf('\t%d raw -> %d unique\n',length(raw_beg_times),length(beg_times))
end
