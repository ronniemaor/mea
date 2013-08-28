function [flatYes,flatNo] = applyFeatures(parms)
    % load the labels
    labels = loadLabels(parms.data.sessionKey, parms.fileSuffix);

    nYes = length(labels.yesTimes);
    nNo = length(labels.noTimes);
    n = nYes + nNo;
    T = labels.T;

    flatYes = [];
    for i=1:nYes
        t = labels.yesTimes(i);
        features = calcOneTime(parms,t,T);
        flatYes = [flatYes; features];
    end
    
    flatNo= [];
    for i=1:nNo
        t = labels.noTimes(i);
        features = calcOneTime(parms,t,T);
        flatNo = [flatNo; features];
    end
end

function features = calcOneTime(parms,t,T)
    features = burstFeatures(parms.data, t, t+T, parms);
    edges = max(features(:,2), features(:,3));
    features = 2 * (0.65*edges + 0.35*features(:,1));
    features = max(features,[],1);    
end