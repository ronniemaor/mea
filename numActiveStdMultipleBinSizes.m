function numActiveStdMultipleBinSizes(parms)
    if ~exist('parms','var'); parms = make_parms(); end
    bShowPvals = take_from_struct(parms,'show_pvals',1);
    pSignificant = take_from_struct(parms,'pval_significance',0.01);
    binSizes = take_from_struct(parms,'bin_sizes',[0.01 0.1 1 10]);
    
    figure; hold on;
    
    nPlots = length(binSizes);
    nRows = 1;
    nCols = nPlots;

    sessionKeys = getSessionKeys(parms);
    numSessions = length(sessionKeys);
    cm = jet(numSessions);
    maxHour = 0;
    for iSession = 1:numSessions;
        data = loadData(sessionKeys{iSession});
        nHours = data.maxUnitFullHours;
        maxHour = max(maxHour, nHours);
        
        for iPlot = 1:nPlots
            parms.estimate_bin_sec = binSizes(iPlot);

            [pActive,~,tBaseBin] = activePerHour(data, parms);
            stats = cellfun(@(x) std(x),pActive);
            baseStat = mean(stats(1:data.nBaselineHours));
            pVals = zeros(1,length(stats));
            baseActivity = cell2mat(pActive(1:data.nBaselineHours));
            for iHour=1:length(stats)
                [~,p] = vartest2(baseActivity,pActive{iHour});
                pVals(iHour) = p;
            end

            subplot(nRows,nCols,iPlot); set(gca, 'FontSize', 16); hold on ;  title(sprintf('bin=%g sec',tBaseBin));
            yStat = stats ./ baseStat;
            plot(yStat, 'Color', cm(iSession,:), 'linewidth', 3);
            if bShowPvals
                significant = find(pVals > pSignificant);
                hSig = plot(significant, yStat(significant), 'x', 'Color', [0 0 0]', 'MarkerSize', 10, 'LineWidth', 2);
                set(get(get(hSig,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude markers from legend
            end
            xlim([0 maxHour])
            ylim([0 2])
            xlabel('Hour number')
            ylabel('\sigma(pActive)')
            hLegend = legend(sessionKeys(1:iSession));
            set(hLegend,'FontSize',8);

            drawnow;
        end
    end
end
