function fname = getLabelsFilename(sessionKey)
    dataDir = fileparts(getSessionDataPath(sessionKey));
    fname = [dataDir '/labels.mat'];
end