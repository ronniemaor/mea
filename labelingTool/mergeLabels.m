function merged = mergeLabels(sessionKey, suffixes, outputSuffix)
    merged = make_parms('sessionKey', sessionKey, 'yesTimes', [], 'noTimes', []);

    for i=1:length(suffixes)
        labels = loadLabels(sessionKey,suffixes{i});
        assert(labels.T == take_from_struct(merged,'T',labels.T));
        assert(labels.contextSize == take_from_struct(merged,'contextSize',labels.contextSize));
        merged.T = labels.T;
        merged.contextSize = labels.contextSize;
        % fromHour and nHours not merged
        merged.yesTimes = [merged.yesTimes labels.yesTimes];
        merged.noTimes = [merged.noTimes labels.noTimes];
        merged.burstStartTimes = [merged.burstStartTimes labels.burstStartTimes];
        merged.burstEndTimes = [merged.burstEndTimes labels.burstEndTimes];
    end

    save(getLabelsFilename(sessionKey,outputSuffix), '-struct', 'merged');
end
