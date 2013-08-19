function path = getSessionDataPath(sessionKey)
    % default dir
    baseDataDir = fullfile('/','cortex', 'data', 'MEA', 'Slutsky2013');
    
    % special cases
    if isequal(getenv('COMPUTERNAME'),'RONNIE-PC')
        baseDataDir = 'C:/data/slutsky2013/data';
    end

    if ~exist(baseDataDir,'dir')
        error(['Could not find baseDataDir ', baseDataDir])
    end
    
    config = getSessionConfig(sessionKey);
    path = [baseDataDir, '/', config.filePath];
end