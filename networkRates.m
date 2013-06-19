function netRate = networkRates(data,maxHour)
    if nargin < 2
        maxHour = data.networkFullHours;
    end
    allRates = zeros(maxHour,data.nUnits);
    for iUnit = 1:data.nUnits
        unitRate = firingRates(data.unitSpikeTimes{iUnit});
        allRates(1:maxHour,iUnit) = unitRate(1:maxHour);        
    end
    netRate = sum(allRates,2);
    plot(netRate)
    xlabel('time [hours]')
    ylabel('firing rate [Hz]')
    title(sprintf('Session %s',data.sessionKey))
end
