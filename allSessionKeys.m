function keys = allSessionKeys()
    sessionConfigs = getAllSessionConfigs();
    keys = fieldnames(sessionConfigs);
end