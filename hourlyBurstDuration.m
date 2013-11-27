function hourlyBurstDuration(data, parms)
    [beg_times, end_times] = infer_all_bursts(data,parms);
    
    tHour = 20*60;
    nHours = data.maxUnitFullHours;
    hourlyDurationMean = zeros(1,nHours);
    hourlyDurationStd = zeros(1,nHours);
    for iHour = 1:nHours
        tStart = (iHour-1)*tHour;
        tEnd = iHour*tHour;
        pos = beg_times>tStart & beg_times<tEnd;
        hourBeg = beg_times(pos);
        hourEnd = end_times(pos);
        durations = hourEnd - hourBeg;
        hourlyDurationMean(iHour) = mean(durations);
        hourlyDurationStd(iHour) = std(durations);
    end
    
    rates = firingRates(cell2mat(data.unitSpikeTimes')) ./ data.nUnits;
    rates = rates(1:nHours);
    
    figure;
    set(gca,'FontSize',16)
    [ax,h1,h2] = plotyy(1:nHours, rates, 1:nHours, hourlyDurationMean);
    title(sprintf('Hourly firing rates and burst rates - %s',data.sessionKey))
    xlabel('Hour number')
    ylabels = {'Firing rate [Hz]', 'Burst duration [s]'};
    hLines = [h1,h2];
    yMax = 1.1 * [max(rates) max(hourlyDurationMean + hourlyDurationStd)];
    for i = 1:2
        set(ax(i),'FontSize',16)
        set(get(ax(i),'Ylabel'),'String',ylabels{i},'FontSize',16) 
        set(hLines(i),'LineWidth',2);
        set(ax(i),'XLim',[0 nHours+1]);
        set(ax(i),'YLim',[0 yMax(i)]);
    end
end
