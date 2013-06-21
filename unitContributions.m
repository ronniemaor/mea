function unitContributions(data)
    tHour = 20*60;
    nHours = data.maxUnitFullHours;
    counts = zeros(data.nUnits, nHours);
    for iUnit=1:data.nUnits
        times = data.unitSpikeTimes{iUnit};
        for iHour = 1:nHours
            startTime = (iHour-1)*tHour;
            endTime = iHour*tHour;
            counts(iUnit, iHour) = sum(times > startTime & times <= endTime);
        end
    end
    contributions = counts ./ repmat(sum(counts),data.nUnits,1);
    nBase = data.nBaselineHours;
    hoursToPlot = [nBase nBase+1, round((nBase+nHours)/2) nHours];
    nPlots = length(hoursToPlot);
    
    figure; set(gca, 'FontSize', 16); hold on;
    edges = linspace(0,max(contributions(:)),100);
    for iPlot = 1:nPlots
        hourNum = hoursToPlot(iPlot);
        subplot(nPlots,1,iPlot)
        pdf = getDistribution(contributions(:,hourNum),edges);
        bar(pdf)
        title(sprintf('Hour number %d',hourNum))
        ylim([0 0.25])
    end
end
