function fname = getLabelsFilename(sessionKey, fileSuffix)
    [path,name,ext] = fileparts(getSessionDataPath(sessionKey));
    fname = sprintf('%s/%s-%s-labels.mat',path,name,fileSuffix);
end