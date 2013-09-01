function [accuracy,svmLabels, svmInstances] = checkAccuracy(parms)
    %parms.fileSuffix = take_from_struct(parms, 'fileSuffix', 'merged-yuval');
    %parms.threshold = take_from_struct(parms, 'threshold', 0.1641);
    %parms.wEdges = take_from_struct(parms, 'wEdges',0.65);
    parms.estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec',0.05);

    % load the labels
    labels = loadLabels(parms.data.sessionKey, parms.fileSuffix);
    nYes = length(labels.yesTimes);
    nNo = length(labels.noTimes);
    n = nYes + nNo;
    T = labels.T;
    
    % convert the data to libsvm input format
    svmInstances = [];
    svmLabels = [];
    for i=1:n
        if i <= nYes
            lbl = 1;
            t = labels.yesTimes(i);
        else
            lbl = -1;
            t = labels.noTimes(i-nYes);
        end
        features = burstFeatures(parms.data, t, t+T, parms);
        
        edges = max(features(:,2), features(:,3));
        p = parms.wEdges;
        scores = p*edges + (1-p)*features(:,1);
        fi = max(scores,[],1); 
        
        svmInstances = [svmInstances; fi];
        svmLabels = [svmLabels; lbl];
    end

    predictedLabels = sign(svmInstances - parms.threshold);
    accuracy = 100 * sum(predictedLabels == svmLabels) / length(svmLabels);
end
