function netRate = networkRates(data)
    maxHour = 35; % this is max hour that appears in all sessions
    allRates = zeros(maxHour,data.nUnits);
    for iUnit = 1:data.nUnits
        unitRate = firingRates(data.unitSpikeTimes{iUnit});
        allRates(1:maxHour,iUnit) = unitRate(1:maxHour);        
    end
    netRate = sum(allRates,2);
    plot(netRate)
    title(sprintf('Session %s',data.sessionKey))
end
