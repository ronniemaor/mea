function baseDataDir = getBaseDataDir()
    baseDataDir = fullfile('/','cortex', 'data', 'MEA', 'Slutsky2013');
    
    if ~exist(baseDataDir,'dir')    
        % try to see if data is next to code dir
        codeDir = fileparts(mfilename('fullpath'));
        baseDataDir = fullfile(codeDir,'..', 'data');
    end

    if ~exist(baseDataDir,'dir')
        error(['Could not find baseDataDir ', baseDataDir])
    end
end
