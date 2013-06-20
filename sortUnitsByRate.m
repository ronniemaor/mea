function data = sortUnitsByRate(data)
    minHour = 1; %data.nBaselineHours + 1;
    maxHour = data.nBaselineHours; % + 1;
    
    % collect the spike counts in the given time range
    spikeCounts = zeros(1,data.nUnits);
    for i=1:data.nUnits
        times = data.unitSpikeTimes{i};
        timesInHours = ceil(times / 20*60);
        spikeCounts(i) = sum(timesInHours >= minHour & timesInHours <= maxHour);
    end
    
    %hist(spikeCounts)
    
    % order the units 
    [~,idx] = sort(spikeCounts,'descend');    
    data.unitSpikeTimes = data.unitSpikeTimes(idx);
    data.unitIds = data.unitIds(idx,:);
end
