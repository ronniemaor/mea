function labelsData = loadLabels(sessionKey,fileSuffix)
    fname = getLabelsFilename(sessionKey, fileSuffix);
    labelsData = load(fname);
end
