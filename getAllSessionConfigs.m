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
        
    % new sessions
    sessionConfigs.bac10e = newConfig('10uM-bac/3.10.13_10uM_bac.mat',4); % done
    sessionConfigs.control1 = newConfig('control/27.9.13_control.mat',4); % done
    sessionConfigs.misc1 = newConfig('misc/1.10.13_15hr control_Mg_HFS.mat',4); % done
    sessionConfigs.misc2 = newConfig('misc/7.3.13 1bKO_10uM_bac.mat',4); % done
    sessionConfigs.misc3 = newConfig('misc/9.5.13_10uM_CNQX.mat',4); % done
    sessionConfigs.misc4 = newConfig('misc/9.7.13_2uM_cntx.mat',4); % PROBLEMATIC. not done. has about 200 negative spike times.
    sessionConfigs.misc5 = newConfig('misc/17.4.13 1bKO_10uM_bac.mat',4); % done
    sessionConfigs.misc6 = newConfig('misc/20.3.13_40uM_CNQX.mat',4); % done. not very stable (firing rate declines steadily in first 4 hours and continues later)
    sessionConfigs.misc7 = newConfig('misc/20.6.13 1aKO_10uM_bac.mat',4); % done
    sessionConfigs.misc8 = newConfig('misc/21.4.13 1bKO_10uM_bac.mat',4); % done
    sessionConfigs.misc9 = newConfig('misc/23.6.13 1aKO_10uM_bac.mat',3); % done
    sessionConfigs.misc10 = newConfig('misc/24.3.13_40uM_CNQX.mat',4); % done
    sessionConfigs.misc11 = newConfig('misc/25.9.13_40uM_CNQX.mat',4); % done. this is very different behavior from 24.3.13_40uM_CNQX. Is it really the same condition?
end

function config = newConfig(filePath, nBaselineHours)
    config = struct;
    config.filePath = filePath;
    config.nBaselineHours = nBaselineHours;
end