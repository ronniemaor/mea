function keys = getSessionKeys(parms)
    if ~exist('parms','var'); parms = make_parms(); end
    sessionFilter = take_from_struct(parms,'filter','');
    
    allConfigs = getAllSessionConfigs();       
    
    if isfield(allConfigs, sessionFilter)
        keys = {sessionFilter};
        return
    end
        
    switch sessionFilter
        case 'bac1'
            keys = {'bac1a', 'bac1b', 'bac1c', 'bac1d'};
        case 'bac10'
            keys = {'bac10a', 'bac10b', 'bac10c', 'bac10d'};
        case 'cnqx40'
            keys  ={'cnqx40a', 'cnqx40b', 'cnqx40c' };
        case 'cntx2'
            keys  ={'cntx2a', 'cntx2b' };
        otherwise
            keys = fieldnames(allConfigs);
    end    

end