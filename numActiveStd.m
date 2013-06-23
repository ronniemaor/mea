function numActiveStd(parms)
    if ~exist('parms','var'); parms = make_parms(); end
    
    figure; hold on;

    sessionKeys = getSessionKeys(parms);
    numSessions = length(sessionKeys);
    cm = jet(numSessions);
    for iSession = 1:numSessions;
        data = loadData(sessionKeys{iSession});
    
        rates = firingRates(cell2mat(data.unitSpikeTimes'));
        rates = rates(1:data.maxUnitFullHours) ./ data.nUnits;
        baseRate = mean(rates(1:data.nBaselineHours));
        [pActivePerHour,~,tBaseBin] = activePerHourWithNormalization(data, parms);
        stats = cellfun(@(x) std(x),pActivePerHour);
        baseStat = mean(stats(1:data.nBaselineHours));

        subplot(1,2,1); set(gca, 'FontSize', 16); hold on ; title('Mean unit firing rate');
        plot(rates ./ baseRate, 'Color', cm(iSession,:), 'linewidth', 3);
        xlabel('Hour number')
        ylabel('Firing rate [Hz]')
        legend(sessionKeys(1:iSession));

        subplot(1,2,2); set(gca, 'FontSize', 16); hold on ;  title(sprintf('\\sigma(pActive) bin=%.1f sec',tBaseBin));
        plot(stats ./ baseStat, 'Color', cm(iSession,:), 'linewidth', 3);
        xlabel('Hour number')
        ylabel('\sigma(pActive)')
        legend(sessionKeys(1:iSession));
        
        drawnow;
    end
end
