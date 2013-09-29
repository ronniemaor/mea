function hourlyBurstStats(data,parms)
    bNormalize = take_from_struct(parms,'bNormalize',true);
    
    tHour = 20*60;
    nHours = data.maxUnitFullHours;
    burstsPerHour = zeros(1,nHours);
    for iHour = 1:nHours
        tStart = (iHour-1)*tHour;
        tEnd = iHour*tHour;
        [beg_times,end_times] = inferBursts(data,tStart,tEnd,parms);
        burstsPerHour(iHour) = length(beg_times);
    end
    burstRatePerHour = burstsPerHour / tHour; % rate = bursts/sec
    
    rates = firingRates(cell2mat(data.unitSpikeTimes')) ./ data.nUnits;
    rates = rates(1:nHours);
    
    if bNormalize
        baselineRate = mean(rates(1:data.nBaselineHours));
        burstRatePerHour = burstRatePerHour ./ (rates / baselineRate);
    end

    figure;
    set(gca,'FontSize',16)
    [ax,h1,h2] = plotyy(1:nHours, rates, 1:nHours, burstRatePerHour);
    strNormalized = ternary(bNormalize,' (normalized)','');
    title(sprintf('Hourly firing rates and burst rates%s - %s',strNormalized,data.sessionKey))
    xlabel('Hour number')
    ylabels = {'Firing rate [Hz]', sprintf('Burst rate%s [Hz]',strNormalized)};
    hLines = [h1,h2];
    yMax = 1.1 * [max(rates) max(burstRatePerHour)];
    for i = 1:2
        set(ax(i),'FontSize',16)
        set(get(ax(i),'Ylabel'),'String',ylabels{i},'FontSize',16) 
        set(hLines(i),'LineWidth',2);
        set(ax(i),'XLim',[0 nHours+1]);
        set(ax(i),'YLim',[0 yMax(i)]);
    end
end

function [raw_beg_times,raw_end_times] = inferBursts(data,tStart,tEnd,parms)
    fprintf('tStart=%g\n',tStart)
    
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
    fprintf('\t%d raw -> %d unique\n',length(raw_beg_times),length(beg_times))
end
