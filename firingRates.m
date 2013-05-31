function r = firingRates(spikeTimes)
    windowSize = 5*60; % in seconds (5 mins)
    nWindows = ceil(max(spikeTimes)/windowSize);
    r = zeros(1,nWindows);
    for iSpike=1:length(spikeTimes)
        t = spikeTimes(iSpike);
        w = ceil(t/windowSize);
        r(w) = r(w) + 1;
    end
    r = r / windowSize; % normalize to Hz
end