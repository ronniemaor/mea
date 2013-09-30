function hourlyBurstStats(data,parms)
    bNormalize = take_from_struct(parms,'bNormalize',true);

    [beg_times, end_times] = infer_all_bursts(data,parms);
    
    tHour = 20*60;
    nHours = data.maxUnitFullHours;
    burstsPerHour = zeros(1,nHours);
    for iHour = 1:nHours
        tStart = (iHour-1)*tHour;
        tEnd = iHour*tHour;
        burstsPerHour(iHour) = length(beg_times(beg_times>tStart & beg_times<tEnd));
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
