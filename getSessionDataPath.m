function path = getSessionDataPath(sessionKey)
    baseDataDir = 'C:/data/slutsky2013/data';
    if ~exist(baseDataDir,'dir')
        error('Could not find baseDataDir')
    end
    
    config = getSessionConfig(sessionKey);
    path = [baseDataDir, '/', config.filePath];
end