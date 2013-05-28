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
    fileData = load(dataFile);
    data = addFromFile(data,fileData);
end

function data = addFromFile(data,fileData)
    data.channelNumbers = [];
    data.channels = cell(1,0);
    nCells = 0;
    allFields = fieldnames(fileData);
    for i = 1:length(allFields)
        f = allFields{i};
        ch = fileData.(f);
        chNum = str2double(f(4:end));
        if ~isempty(ch)
            nCells = nCells + 1;
            data.channelNumbers(nCells) = chNum;
            data.channels{nCells} = ch;
        end
    end
end
