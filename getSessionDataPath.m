function path = getSessionDataPath(sessionKey)

  switch computer
   case 'GLNXA64'
    baseDataDir = fullfile('/','cortex', 'data', 'MEA', 'Slutsky2013');    
   case 'PCWIN'
    baseDataDir = 'C:/data/slutsky2013/data';
  end

  if ~exist(baseDataDir,'dir')
    error(['Could not find baseDataDir ', baseDataDir])
  end
    
  config = getSessionConfig(sessionKey);
  path = [baseDataDir, '/', config.filePath];
end