function path = getSessionDataPath(sessionKey)
    baseDataDir = getBaseDataDir();
    config = getSessionConfig(sessionKey);
    path = [baseDataDir, '/', config.filePath];
end