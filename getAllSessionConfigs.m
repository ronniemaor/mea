function sessionConfigs = getAllSessionConfigs()
    sessionConfigs = struct;
    sessionConfigs.s1a = newConfig('1uM bac/2.9.12_filtered.mat');
    sessionConfigs.s1b = newConfig('1uM bac/13.3.13_final_filtered.mat');
    sessionConfigs.s10a = newConfig('10uM bac/16.3.13_final_filtered.mat');
    sessionConfigs.s10b = newConfig('10uM bac/16.10.12_filtered.mat');
end

function config = newConfig(filePath)
    config = struct;
    config.filePath = filePath;
end