function [model,accuracy] = showROC(parms)
    parms.wEdges = take_from_struct(parms,'wEdges',0.65);
    parms.estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec',0.05);
    parms.threshold = take_from_struct(parms, 'threshold', 0.1641);

    % load the labels
    fname = getLabelsFilename(parms.data.sessionKey, parms.fileSuffix);
    labelsData = load(fname);

    nYes = length(labelsData.yesTimes);
    nNo = length(labelsData.noTimes);
    n = nYes + nNo;
    T = labelsData.T;
    
    % convert the data to libsvm input format
    instances = zeros(n,1);
    labels = zeros(n,1);
    for i=1:n
        if i <= nYes
            lbl = 1;
            t = labelsData.yesTimes(i);
        else
            lbl = -1;
            t = labelsData.noTimes(i-nYes);
        end
        features = burstFeatures(parms.data, t, t+T, parms);
        activity = features(:,1);
        posEdges = features(:,2);
        negEdges = features(:,3);
        edges = max(posEdges, negEdges);
        p = parms.wEdges;
        scores = p*edges + (1-p)*activity;
        fi = max(scores,[],1); 
        
        instances(i) = fi;
        labels(i) = lbl;
    end
    predictedLabels = sign(instances - parms.threshold);
    classificationTPR = sum(labels==1 & predictedLabels==1)/sum(labels==1);
    classificationFPR = sum(labels==-1 & predictedLabels==1)/sum(labels==-1);
    
    % no need for projection for ROC, since we're already in one dimension
    [~,fpr,tpr] = myauc(labels == 1,instances);
    
    figure;
    set(gca,'FontSize',16);
    plot(fpr,tpr,'b-');
    hold on
    plot(classificationFPR,classificationTPR,'or','MarkerSize',8,'MarkerFaceColor','r')
    title(sprintf('ROC for %s',parms.data.sessionKey));
    xlabel('False Positive');
    ylabel('True Positive');    
end
