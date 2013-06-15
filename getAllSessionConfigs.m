function sessionConfigs = getAllSessionConfigs()
    sessionConfigs = struct;
    sessionConfigs.s1a = newConfig('1uM-bac/2.9.12_filtered.mat');
    sessionConfigs.s1b = newConfig('1uM-bac/13.3.13_final_filtered.mat');
    sessionConfigs.s1c = newConfig('1uM-bac/6.12.12_filtered.mat');
    sessionConfigs.s1d = newConfig('1uM-bac/19.11.12_filtered.mat');
    
    sessionConfigs.s10a = newConfig('10uM-bac/16.3.13_final_filtered.mat');
    sessionConfigs.s10b = newConfig('10uM-bac/16.10.12_filtered.mat');
    sessionConfigs.s10c = newConfig('10uM-bac/4.12.12_filtered.mat');
    sessionConfigs.s10d = newConfig('10uM-bac/9.10.12_filtered.mat');
    
    sessionConfigs.s40a = newConfig('40uM-CNQX/10.2.13_final-filtered.mat');
    sessionConfigs.s40b = newConfig('40uM-CNQX/27.1.13.mat');
    sessionConfigs.s40c = newConfig('40uM-CNQX/27.3.13_final.mat');
end

function config = newConfig(filePath)
    config = struct;
    config.filePath = filePath;
end