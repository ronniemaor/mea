function hourlyBurstRate(parms)
    parms.T = take_from_struct(parms, 'T',0.5);
    parms.wEdges = take_from_struct(parms, 'wEdges',0.65);
    parms.estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec',0.05);
    parms.threshold = take_from_struct(parms, 'threshold', 0.1641);
    bNormalize = take_from_struct(parms,'bNormalize',true);
    
    tHour = 20*60;
    nHours = parms.data.maxUnitFullHours;
    burstsPerHour = zeros(1,nHours);
    for iHour = 1:nHours
        tStart = (iHour-1)*tHour;
        tEnd = iHour*tHour;
        features = burstFeatures(parms.data, tStart, tEnd, parms);
        activity = features(:,1);
        posEdges = features(:,2);
        negEdges = features(:,3);
        edges = max(posEdges, negEdges);
        p = parms.wEdges;
        scores = p*edges + (1-p)*activity;
        burstsPerHour(iHour) = sum(scores > parms.threshold);
    end
    burstRatePerHour = burstsPerHour / tHour; % rate = bursts/sec
    
    rates = firingRates(cell2mat(parms.data.unitSpikeTimes')) ./ parms.data.nUnits;
    rates = rates(1:nHours);
    
    if bNormalize
        baselineRate = mean(rates(1:parms.data.nBaselineHours));
        burstRatePerHour = burstRatePerHour ./ (rates / baselineRate);
    end

    figure;
    set(gca,'FontSize',16)
    [ax,h1,h2] = plotyy(1:nHours, rates, 1:nHours, burstRatePerHour);
    strNormalized = ternary(bNormalize,' (normalized)','');
    title(sprintf('Hourly firing rates and burst rates%s - %s',strNormalized,parms.data.sessionKey))
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
