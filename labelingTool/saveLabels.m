function saveLabels(parms,state)
    x = struct;
    x.T = parms.T;
    x.contextSize = parms.contextSize;
    x.fromHour = parms.fromHour;
    x.nHours = parms.nHours;
    x.sessionKey = parms.data.sessionKey;
    x.yesTimes = state.yesTimes;
    x.noTimes = state.noTimes;
    
    fname = getLabelsFilename(parms.data.sessionKey, parms.fileSuffix);
    save(fname, '-struct', 'x');
end
