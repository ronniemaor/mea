function [beg_times, end_times] = infer_all_bursts(data,parms,bForce)
    if ~exist('bForce','var')
        bForce = false;
    end

    baseDataDir = getBaseDataDir();
    fname = sprintf('%s/cache/burst-edges-%s.mat',baseDataDir,data.sessionKey);
    
    if exist(fname,'file') && ~bForce
        cache = load(fname);
        beg_times = cache.beg_times;
        end_times = cache.end_times;
        return 
    end
    
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
    fprintf('Infer burst beginnings\n')
    raw_beg_times = infer_burst_edge(n_active, peak_times, models.beg_model, parms, S, NaN, true, data);
    fprintf('Infer burst endings\n')
    raw_end_times = infer_burst_edge(n_active, peak_times, models.end_model, parms, S, NaN, false, data, raw_beg_times);
    
    % remove overlapping bursts
    fprintf('Remove overlapping bursts\n')
    lastEnd = -1;
    for i=1:length(raw_beg_times)
        if raw_beg_times(i) > lastEnd && raw_end_times(i) > raw_beg_times(i)
            lastEnd = raw_end_times(i);
        else
            raw_beg_times(i) = NaN;
            raw_end_times(i) = NaN;
        end
    end
    beg_times = raw_beg_times(~isnan(raw_beg_times));
    end_times = raw_end_times(~isnan(raw_end_times));
    
    save(fname,'beg_times','end_times');
end
