function data = loadData(sessionKey, bSilent)
    if nargin < 2
        bSilent = 0;
    end    
    sessionConfig = getSessionConfig(sessionKey);
    dataFile = getSessionDataPath(sessionKey);
    if ~bSilent
        fprintf('Loading %s (from %s)\n', sessionKey, dataFile)
    end
    data = struct;
    data.sessionKey = sessionKey;
    data.dataFile = dataFile;
    data.nBaselineHours = sessionConfig.nBaselineHours;
    fileData = load(dataFile);
    data = addFromFile(data,fileData);
end

function data = addFromFile(data,fileData)
    shortUnitThreshold = 7; % ignore units that don't have spikes for at least this number of hours
    
    data.channelNumbers = [];
    data.channels = cell(1,0);
    data.unitIds = [];
    data.unitSpikeTimes = cell(1,0);
    data.unitFullHours = [];
    nChannels = 0;
    nUnits = 0;
    nShortUnits = 0;
    allFields = fieldnames(fileData);
    for iField = 1:length(allFields)
        f = allFields{iField};
        ch = fileData.(f);
        chNum = str2double(f(4:end));
        if isempty(ch)
            continue
        end
        nChannels = nChannels + 1;
        data.channelNumbers(nChannels) = chNum;
        data.channels{nChannels} = ch;
        units = unique(ch(:,2));
        for iUnit = 1:length(units)
            unitNum = units(iUnit);
            unitRows = ch(:,2) == unitNum;
            unitTimes = ch(unitRows,3);
            nFullHours = round(max(unitTimes)/1200); % "hour" is only 20 minutes. Count the hour if it had a spike its 2nd half
            if nFullHours < shortUnitThreshold
                nShortUnits = nShortUnits + 1;
                continue
            end
            nUnits = nUnits + 1;
            data.unitIds(nUnits,1:2) = [chNum unitNum];
            data.unitSpikeTimes{nUnits} = unitTimes;
            data.unitFullHours(nUnits) = nFullHours;
        end        
    end
    data.networkFullHours = min(data.unitFullHours);
    data.maxUnitFullHours = max(data.unitFullHours);
    data.nChannels = nChannels;
    data.nUnits = nUnits;
    data.nDiscardedShortUnits = nShortUnits;
end
