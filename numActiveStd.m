function numActiveStd(parms)
    if ~exist('parms','var'); parms = make_parms(); end
    bShowPvals = take_from_struct(parms,'show_pvals',1);
    pSignificant = take_from_struct(parms,'pval_significance',0.01);
    
    figure; hold on;

    sessionKeys = getSessionKeys(parms);
    numSessions = length(sessionKeys);
    cm = jet(numSessions);
    maxHour = 0;
    for iSession = 1:numSessions;
        data = loadData(sessionKeys{iSession});
        nHours = data.maxUnitFullHours;
        maxHour = max(maxHour, nHours);
    
        rates = firingRates(cell2mat(data.unitSpikeTimes'));
        rates = rates(1:data.maxUnitFullHours) ./ data.nUnits;
        baseRate = mean(rates(1:data.nBaselineHours));
        [pActivePerHour,~,tBaseBin] = activePerHourWithNormalization(data, parms);
        stats = cellfun(@(x) std(x),pActivePerHour);
        baseStat = mean(stats(1:data.nBaselineHours));
        pVals = zeros(1,length(stats));
        baseActivity = cell2mat(pActivePerHour(1:data.nBaselineHours));
        for iHour=1:length(stats)
            [~,p] = vartest2(baseActivity,pActivePerHour{iHour});
            pVals(iHour) = p;
        end
        
        subplot(1,2,1); set(gca, 'FontSize', 16); hold on ; title('Mean unit firing rate');
        plot(rates ./ baseRate, 'Color', cm(iSession,:), 'linewidth', 3);
        xlim([0 maxHour])
        xlabel('Hour number')
        ylabel('Firing rate [Hz]')
        legend(sessionKeys(1:iSession));

        subplot(1,2,2); set(gca, 'FontSize', 16); hold on ;  title(sprintf('\\sigma(pActive) bin=%.1f sec',tBaseBin));
        yStat = stats ./ baseStat;
        plot(yStat, 'Color', cm(iSession,:), 'linewidth', 3);
        if bShowPvals
            significant = find(pVals > pSignificant);
            hSig = plot(significant, yStat(significant), 'x', 'Color', [0 0 0]', 'MarkerSize', 10, 'LineWidth', 2);
            set(get(get(hSig,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude markers from legend
        end
        xlim([0 maxHour])
        xlabel('Hour number')
        ylabel('\sigma(pActive)')
        legend(sessionKeys(1:iSession));
        
        drawnow;
    end
end
