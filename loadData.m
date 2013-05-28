function data = loadData(sessionKey, bSilent)
    if nargin < 2
        bSilent = 0;
    end
    dataFile = getSessionDataPath(sessionKey);
    if ~bSilent
        fprintf('Loading %s (from %s)\n', sessionKey, dataFile)
    end
    data = load(dataFile);
    data.sessionKey = sessionKey;
end
