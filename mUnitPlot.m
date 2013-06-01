function mUnitPlot(data, f, ttl)
    nPlots = data.nUnits;
    nRows = ceil(sqrt(nPlots));
    nCols = ceil(nPlots/nRows);
    figure;
    for iUnit=1:data.nUnits
        ISIs = calcISIs(data.unitSpikeTimes{iUnit});
        stats = cellfun(f, ISIs);
        subplot(nRows,nCols,iUnit)
        maxFrame = 35;
        plot(stats(1:maxFrame));
        xlim([1 maxFrame])
    end
    if exist('ttl','var')
        topLevelTitle(ttl)
    end
end
