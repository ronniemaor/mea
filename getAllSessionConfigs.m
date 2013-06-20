function sessionConfigs = getAllSessionConfigs()
    sessionConfigs = struct;
    sessionConfigs.s1a = newConfig('1uM-bac/2.9.12_filtered.mat',3);
    sessionConfigs.s1b = newConfig('1uM-bac/13.3.13_final_filtered.mat',4);
    sessionConfigs.s1c = newConfig('1uM-bac/6.12.12_filtered.mat',3);
    sessionConfigs.s1d = newConfig('1uM-bac/19.11.12_filtered.mat',3);
    
    sessionConfigs.s10a = newConfig('10uM-bac/16.3.13_final_filtered.mat',4);
    sessionConfigs.s10b = newConfig('10uM-bac/16.10.12_filtered.mat',3);
    sessionConfigs.s10c = newConfig('10uM-bac/4.12.12_filtered.mat',3);
    sessionConfigs.s10d = newConfig('10uM-bac/9.10.12_filtered.mat',3);
    
%     sessionConfigs.s40a = newConfig('40uM-CNQX/10.2.13_final-filtered.mat',4);
%     sessionConfigs.s40b = newConfig('40uM-CNQX/27.1.13.mat',3);
%     sessionConfigs.s40c = newConfig('40uM-CNQX/27.3.13_final.mat',4);
end

function config = newConfig(filePath, nBaselineHours)
    config = struct;
    config.filePath = filePath;
    config.nBaselineHours = nBaselineHours;
end