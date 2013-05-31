function r = firingRates(spikeTimes,windowSize)
    if nargin < 2
        windowSize = 20*60; % in seconds (20 mins)
    end
    nWindows = ceil(max(spikeTimes)/windowSize);
    r = zeros(1,nWindows);
    for iSpike=1:length(spikeTimes)
        t = spikeTimes(iSpike);
        w = ceil(t/windowSize);
        r(w) = r(w) + 1;
    end
    r = r / windowSize; % normalize to Hz
end