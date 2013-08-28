function showROC(parms)
    parms.wEdges = take_from_struct(parms,'wEdges',0.65);
    parms.estimate_bin_sec = take_from_struct(parms, 'estimate_bin_sec',0.05);
    parms.threshold = take_from_struct(parms, 'threshold', 0.1641);
    
    figure; set(gca,'FontSize',16);
    
    nFiles= length(parms.suffixes);
    fileROC = struct;
    
    for iFile = 1:nFiles
        % load the labels
        suffix = parms.suffixes{iFile};
        labelsData = loadLabels(parms.data.sessionKey, suffix);
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
        fileROC(iFile).classificationTPR = sum(labels==1 & predictedLabels==1)/sum(labels==1);
        fileROC(iFile).classificationFPR = sum(labels==-1 & predictedLabels==1)/sum(labels==-1);

        % no need for projection for ROC, since we're already in one dimension
        [auc,fpr,tpr] = myauc(labels == 1,instances);
        fileROC(iFile).fpr = fpr;
        fileROC(iFile).tpr = tpr;
        fileROC(iFile).strLegend = sprintf('%s - AUC=%.2f',suffix,auc);
    end

    for iFile=1:nFiles
        plot(fileROC(iFile).fpr,fileROC(iFile).tpr);
        hold all
    end
    legend({fileROC.strLegend},'Location','SouthEast')
    for iFile=1:nFiles
        plot(fileROC(iFile).classificationFPR,fileROC(iFile).classificationTPR,'or','MarkerSize',8,'MarkerFaceColor','r')
    end
    title(sprintf('ROC for %s',parms.data.sessionKey));
    axis('equal')
    xlim([0 1]);
    ylim([0 1])
    xlabel('False Positive');
    ylabel('True Positive');    
end
