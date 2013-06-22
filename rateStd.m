function rateStd(parms)
    if ~exist('parms','var'); parms = make_parms(); end
    
    figure; hold on;

    sessionKeys = getSessionKeys(parms);
    numSessions = length(sessionKeys);
    cm = jet(numSessions);
    for iSession = 1:numSessions;
        data = loadData(sessionKeys{iSession});
        
        [counts, tBin] = spikesPerHourAndBin(data,parms); % unit x bin x hour
        [nUnits,nBins,nHours] = size(counts);

        hourRates = squeeze(msum(counts,[1 2]))/(nUnits*nBins);
        
        hourBinRates = squeeze(sum(counts,1))/nUnits; % bin x hour
        stats = zeros(1,nHours);
        for iHour=1:nHours
            stats(iHour) = std(hourBinRates(:,iHour));
        end
        
        subplot(1,2,1); set(gca, 'FontSize', 16); hold on ; title('Firing rates (all units together)');
        plot(hourRates, 'Color', cm(iSession,:), 'linewidth', 3);
        xlabel('Hour number')
        ylabel('Firing rate [Hz]')
        legend(sessionKeys(1:iSession));

        subplot(1,2,2); set(gca, 'FontSize', 16); hold on ;  title(sprintf('std(firing rate) binSize=%.1f sec',tBin));
        plot(stats, 'Color', cm(iSession,:), 'linewidth', 3);
        xlabel('Hour number')
        ylabel('std(firing rate)')
        legend(sessionKeys(1:iSession));
        
        drawnow;
    end
end

