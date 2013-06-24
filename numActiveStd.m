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

        subplot(1,3,1); set(gca, 'FontSize', 16); hold on ; title('Mean unit firing rate');
        plot(rates ./ baseRate, 'Color', cm(iSession,:), 'linewidth', 3);
        xlim([0 maxHour])
        xlabel('Hour number')
        ylabel('Firing rate')
        legend(sessionKeys(1:iSession), 'Location', 'SouthEast');
        legend('boxoff')

        for bNormalize = 0:1
            [pActive,~,tBaseBin] = activePerHour(data, add_parms(parms,'normalize',bNormalize));
            stats = cellfun(@(x) std(x),pActive);
            baseStat = mean(stats(1:data.nBaselineHours));
            pVals = zeros(1,length(stats));
            baseActivity = cell2mat(pActive(1:data.nBaselineHours));
            for iHour=1:length(stats)
                [~,p] = vartest2(baseActivity,pActive{iHour});
                pVals(iHour) = p;
            end

            subplot(1,3,2+bNormalize); set(gca, 'FontSize', 16); hold on;  
            if bNormalize
                strNormalized = 'normalized for rate';
            else
                strNormalized = 'not normalized for rate';
            end
            ttl = sprintf('\\sigma(num active units)\nbin=%.1f sec\n%s',tBaseBin,strNormalized);
            title(ttl);
            yStat = stats ./ baseStat;
            plot(yStat, 'Color', cm(iSession,:), 'linewidth', 3);
            if bShowPvals
                significant = find(pVals > pSignificant);
                hSig = plot(significant, yStat(significant), 'x', 'Color', [0 0 0]', 'MarkerSize', 10, 'LineWidth', 2);
                set(get(get(hSig,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude markers from legend
            end
            xlim([0 maxHour])
            xlabel('Hour number')
            ylabel('\sigma(num active units)')
        end
        
        drawnow;
    end
    
    % set both std(pActive) plots to same ylim
    h2 = subplot(1,3,2);
    h3 = subplot(1,3,3);
    y2 = ylim(h2);
    y3 = ylim(h3);
    ymax = max(y2(2),y3(2));
    ylim(h2, [0, ymax]); 
    ylim(h3, [0, ymax]); 
end
