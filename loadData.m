function data = loadData(sessionKey, bSilent)
    if nargin < 2
        bSilent = 0;
    end
    dataFile = getSessionDataPath(sessionKey);
    if ~bSilent
        fprintf('Loading %s (from %s)\n', sessionKey, dataFile)
    end
    data = struct;
    data.sessionKey = sessionKey;
    data.dataFile = dataFile;
    fileData = load(dataFile);
    data = addFromFile(data,fileData);
end

function data = addFromFile(data,fileData)
    data.channelNumbers = [];
    data.channels = cell(1,0);
    data.unitIds = [];
    data.unitSpikeTimes = cell(1,0);
    nChannels = 0;
    nUnits = 0;
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
            nUnits = nUnits + 1;
            data.unitIds(nUnits,1:2) = [chNum unitNum];
            unitRows = ch(:,2) == unitNum;
            data.unitSpikeTimes{nUnits} = ch(unitRows,3);
        end        
    end
    data.nChannels = nChannels;
    data.nUnits = nUnits;
end
