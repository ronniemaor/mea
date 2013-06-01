function ISIs = calcISIs(spikeTimes,windowSize)
    if nargin < 2
        windowSize = 20*60; % in seconds (20 mins)
    end
    nWindows = ceil(max(spikeTimes)/windowSize);
    ISIs = cell(1,nWindows); % array ISI times for each time window
    for iWindow = 1:nWindows
        tEnd = iWindow*windowSize;
        tStart = tEnd - windowSize;
        t = spikeTimes(spikeTimes > tStart & spikeTimes <= tEnd);
        ISIs{iWindow} = diff(t);
    end
end