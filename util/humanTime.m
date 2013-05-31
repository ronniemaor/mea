function strTime = humanTime(t)
    secs = mod(t,60);
    totalMins = floor(t/60);
    mins = mod(totalMins,60);
    hours = floor(totalMins/60);
    strTime = sprintf('%d:%d:%d',hours,mins,secs);
end