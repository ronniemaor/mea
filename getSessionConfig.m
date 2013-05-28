function config = getSessionConfig(sessionKey)
    allConfigs = getAllSessionConfigs();
    config = allConfigs.(sessionKey);
end