function numActiveStd(parms)
    if ~exist('parms','var'); parms = make_parms(); end
    sessionFilter = take_from_struct(parms,'filter','');
    
    f = @(x) std(x);

    figure; hold on;

    sessionConfigs = getAllSessionConfigs();
    switch sessionFilter
        case 's1'
            sessionNames = {'s1a', 's1b', 's1c', 's1d'};
        case 's10'
            sessionNames = {'s10a', 's10b', 's10c', 's10d'};
        otherwise
            sessionNames = fieldnames(sessionConfigs);
    end    
    numSessions = length(sessionNames);
    cm = jet(numSessions);
    for iSession = 1:numSessions;
        sessionKey = sessionNames{iSession};

        data = loadData(sessionKey);
    
        rates = firingRates(cell2mat(data.unitSpikeTimes'));
        rates = rates(1:data.maxUnitFullHours);
        [pActive,tBin] = activePerHour(data, parms);
        stats = cellfun(f,pActive);
            
        subplot(1,2,1); hold on ; title('Firing rates (all units together)');
        plot(rates, 'Color', cm(iSession,:), 'linewidth', 3);
        xlabel('Hour number')
        ylabel('Firing rate [Hz]')
        legend(sessionNames(1:iSession));

        subplot(1,2,2); hold on ;  title(sprintf('\\sigma(pActive) binSize=%.1f sec',tBin));
        plot(stats, 'Color', cm(iSession,:), 'linewidth', 3);
        xlabel('Hour number')
        ylabel('\sigma(pActive)')
        legend(sessionNames(1:iSession));
        
        drawnow;
    end
end
