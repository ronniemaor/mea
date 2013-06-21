function [activePerHour, tBin] = activePerHour(data, parms)
    [numActive, binTimes] = num_units_active(data, parms);
    pActive = numActive / data.nUnits;
    tHour = 20*60;
    nHours = floor(max(binTimes) / tHour);
    
    activePerHour = cell(1,nHours);
    for iHour = 1:nHours
        startTime = (iHour-1)*tHour;
        endTime = iHour*tHour;        
        activePerHour{iHour} = pActive(binTimes > startTime & binTimes <= endTime);
    end
    tBin = binTimes(1);
end
