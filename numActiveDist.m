function numActiveDist(data,parms)
    if ~exist('parms','var'); parms = make_parms(); end

    nHours = data.maxUnitFullHours;    
    
    frames = take_from_struct(parms,'frames',[]);
    if isempty(frames)
        frames = 1:nHours;
    end
    
    [pActivePerHour,~,tBaseBin] = activePerHourWithNormalization(data, parms);
    rates = firingRates(cell2mat(data.unitSpikeTimes'));
    rates = rates(1:nHours);

    binJumps = take_from_struct(parms,'hist_bin',0.1);
    edges = 0:binJumps:1;
    f = @(x) getDistribution(x,edges(2:end));
    pdfs = cellfun(f,pActivePerHour,'UniformOutput',0);
    maxP = max(cell2mat(pdfs));
    
    figure;
    nPlots = length(frames);
    [nRows, nCols] = rectSubplot(nPlots);
    for iPlot=1:nPlots
        subplot(nRows,nCols,iPlot)
        iHour = frames(iPlot);
        bar(edges,pdfs{iHour});
        xlim([0 1])
        ylim([0 maxP])
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        title(sprintf('hour %d (%.0fHz)', iHour, rates(iHour)))
    end
    topLevelTitle(sprintf('Distribution of active-units-fraction - %s (bin=%.1f sec)', data.sessionKey, tBaseBin))
