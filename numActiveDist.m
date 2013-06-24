function numActiveDist(data,parms)
    if ~exist('parms','var'); parms = make_parms(); end
    bSubplots = take_from_struct(parms,'subplots',0);

    nHours = data.maxUnitFullHours;    
    
    frames = take_from_struct(parms,'frames',[]);
    if isempty(frames)
        frames = 1:nHours;
    end
    
    [pActive,~,tBaseBin] = activePerHour(data, parms);
    rates = firingRates(cell2mat(data.unitSpikeTimes'));
    rates = rates(1:nHours);

    binJumps = take_from_struct(parms,'hist_bin',0.1);
    edges = 0:binJumps:1;
    f = @(x) getDistribution(x,edges(2:end));
    pdfs = cellfun(f,pActive,'UniformOutput',0);
    maxP = max(cell2mat(pdfs));
    
    figure;    

    if bSubplots
        nPlots = length(frames);
        [nRows, nCols] = rectSubplot(nPlots);
        for iPlot=1:nPlots
            subplot(nRows,nCols,iPlot); set(gca, 'FontSize', 16)
            iHour = frames(iPlot);
            bar(edges,pdfs{iHour});
            xlim([0 1])
            ylim([0 maxP])
            set(gca,'XTick',[])
            set(gca,'YTick',[])
            title(sprintf('hour %d (%.0fHz)', iHour, rates(iHour)))
        end
        topLevelTitle(sprintf('Distribution of active-units-fraction - %s (bin=%.1f sec)', data.sessionKey, tBaseBin))
    else
        set(gca, 'FontSize', 16);
        nPlots = length(frames);
        for iPlot=1:nPlots
            iHour = frames(iPlot);
            plot(edges,pdfs{iHour}, 'LineWidth', 2); hold all;
            xlim([0 1])
            ylim([0 maxP])
            title(sprintf('Distributions of active units at different times - %s', data.sessionKey))
        end
        formatLegend = @(iHour) sprintf('Hour %d',iHour);
        legend(arrayfun(formatLegend, frames, 'UniformOutput', 0));
    end
end