function keys = getSessionKeys(parms)
    if ~exist('parms','var'); parms = make_parms(); end
    sessionFilter = take_from_struct(parms,'filter','');
    
    allConfigs = getAllSessionConfigs();       
    
    if isfield(allConfigs, sessionFilter)
        keys = {sessionFilter};
        return
    end
        
    switch sessionFilter
        case 's1'
            keys = {'s1a', 's1b', 's1c', 's1d'};
        case 's10'
            keys = {'s10a', 's10b', 's10c', 's10d'};
        case 's40'
            keys  ={'s40a', 's40b', 's40c' };
        otherwise
            keys = fieldnames(allConfigs);
    end    

end