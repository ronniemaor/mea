function numActiveDist(data,parms)
    if ~exist('parms','var'); parms = make_parms(); end
    
    nHours = data.maxUnitFullHours;
    [pActive,tBin] = activePerHour(data, parms);
    rates = firingRates(cell2mat(data.unitSpikeTimes'));
    rates = rates(1:nHours);

    binJumps = take_from_struct(parms,'hist_bin',0.1);
    edges = 0:binJumps:1;
    f = @(x) getDistribution(x,edges(2:end));
    pdfs = cellfun(f,pActive,'UniformOutput',0);
    maxP = max(cell2mat(pdfs));
    
    figure;
    [nRows, nCols] = rectSubplot(nHours);
    for iHour=1:nHours
        subplot(nRows,nCols,iHour)
        bar(edges,pdfs{iHour});
        xlim([0 1])
        ylim([0 maxP])
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        title(sprintf('hour %d (%.0fHz)', iHour, rates(iHour)))
    end
    topLevelTitle(sprintf('Distribution of active-units-fraction - %s (bin=%.1f sec)', data.sessionKey, tBin))
