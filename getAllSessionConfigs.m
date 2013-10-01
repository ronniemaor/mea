function sessionConfigs = getAllSessionConfigs()
    sessionConfigs = struct;
    sessionConfigs.bac1a = newConfig('1uM-bac/2.9.12_filtered.mat',3);
    sessionConfigs.bac1b = newConfig('1uM-bac/13.3.13_final_filtered.mat',4);
    sessionConfigs.bac1c = newConfig('1uM-bac/6.12.12_filtered.mat',3);
    sessionConfigs.bac1d = newConfig('1uM-bac/19.11.12_filtered.mat',3);
    
    sessionConfigs.bac10a = newConfig('10uM-bac/16.3.13_final_filtered.mat',4);
    sessionConfigs.bac10b = newConfig('10uM-bac/16.10.12_filtered.mat',3);
    sessionConfigs.bac10c = newConfig('10uM-bac/4.12.12_filtered.mat',3);
    sessionConfigs.bac10d = newConfig('10uM-bac/9.10.12_filtered.mat',3);
    
    sessionConfigs.cnqx40a = newConfig('40uM-CNQX/10.2.13_final-filtered.mat',4);
    sessionConfigs.cnqx40b = newConfig('40uM-CNQX/27.1.13.mat',3);
    sessionConfigs.cnqx40c = newConfig('40uM-CNQX/27.3.13_final.mat',4);
    
    sessionConfigs.cntx2a = newConfig('2uM-cntx/11.4.13_2uM_cntx.mat',3);
    sessionConfigs.cntx2b = newConfig('2uM-cntx/27.6.13_2uM_cntx.mat',4);    
    sessionConfigs.cntx2c = newConfig('2uM-cntx/30.6.13_2uM_cntx.mat',4);     
    % sessionConfigs.cntx2d = newConfig('2uM-cntx/9.7.13_2uM_cntx.mat',4); % first hour are blank due to technical issues
                                                                           % This caused all units to be discarded as unstable 
    
    sessionConfigs.aga200a = newConfig('200nM-aga/21.7.13_200nM_aga.mat',4);
end

function config = newConfig(filePath, nBaselineHours)
    config = struct;
    config.filePath = filePath;
    config.nBaselineHours = nBaselineHours;
end