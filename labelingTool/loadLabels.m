function labelsData = loadLabels(sessionKey,fileSuffix)
    fname = getLabelsFilename(sessionKey, fileSuffix);
    labelsData = load(fname);
    
    % lazy conversion of labels
    if ~isfield(labelsData,'burstStartTimes');
        labelsData.burstStartTimes = NaN * zeros(size(labelsData.yesTimes));
        labelsData.burstEndTimes = NaN * zeros(size(labelsData.yesTimes));
    end
end
