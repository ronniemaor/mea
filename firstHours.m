function firstHours(data)
    fRate = @(x) 1/mean(x); % get average rate from ISI distribution
    maxFrame = 4;
    allStats = zeros(data.nUnits,maxFrame);
    for iUnit=1:data.nUnits
        ISIs = calcISIs(data.unitSpikeTimes{iUnit});
        unitStats = cellfun(fRate, ISIs);
        unitStats = unitStats / unitStats(1); % normalize to first hour
        allStats(iUnit,:) = unitStats(1:maxFrame)';
    end
    errorbar(mean(allStats),std(allStats)/sqrt(data.nUnits));
    title(sprintf('Mean rates before baclofen - session %s',data.sessionKey))
    xlabel('Hour number')
    ylabel('Rate_k / Rate_1 (mean \pm sem)')
    set(gca,'XTick',1:maxFrame)
end
