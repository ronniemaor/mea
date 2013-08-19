function train(parms)
    % load the labels
    fname = getLabelsFilename(parms.data.sessionKey, parms.fileSuffix);
    labels = load(fname);

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
        scores = 2 * (0.65*edges + 0.35*features(:,1));     
        fi = max(scores,[],1); 
        if lbl == 1 && fi < 0.07
            continue
        end
        
        svmInstances = [svmInstances; fi];
        svmLabels = [svmLabels; lbl];
    end
    
    lstC = take_from_struct(parms,'lstC',logspace(-3,3,10));
    [cvAccuracy,~,overfitAccuracy] = arrayfun(@(C) tryHyper(svmLabels,svmInstances,C, parms), lstC);
    figure;
    plot(log10(lstC),100*cvAccuracy,'b-',log10(lstC),100*overfitAccuracy,'r-');
    title('accuracy(C)');
    xlabel('log_{10}(C)')
    ylabel('accuracy (%correct)')
    legend({'cross validation', 'overfitted'}, 'Location', 'NorthEastOutside')
end

function [cvAccuracy,model,overfitAccuracy] = tryHyper(svmLabels,svmInstances, C, parms)
    nFolds = 5;
    
    idxYes = find(svmLabels == 1);
    idxNo = find(svmLabels == -1);
    
    if length(idxYes) > length(idxNo)
        smallLabel = -1;
        idxBig = idxYes;
        idxSmall = idxNo;
    else
        smallLabel = 1;
        idxBig = idxNo;
        idxSmall = idxYes;
    end
    nBig = length(idxBig);
    nSmall = length(idxSmall);

    idxBig = idxBig(randperm(nBig));
    idxSmall = idxSmall(randperm(nSmall));
    
    bigFolds = divideToBins(idxBig,nFolds);
    smallFolds = divideToBins(idxSmall,nFolds);
    strOptions = sprintf('-t 0 -q -c %f -w%d %.1f', C, smallLabel, 0.99*nBig/nSmall);
    accuracies = zeros(1,nFolds);
    for iFold = 1:nFolds
        if isempty(smallFolds{iFold})
            accuracies(iFold) = NaN;
            continue;
        end
        idxFold = [bigFolds{iFold}; smallFolds{iFold}];
        accuracies(iFold) = trainOne(svmLabels(idxFold), svmInstances(idxFold), strOptions, parms);
    end
    cvAccuracy = nanmean(accuracies);

    [overfitAccuracy, model] = trainOne(svmLabels, svmInstances, strOptions, parms);
end

function [accuracy,model] = trainOne(labels,instances,strOptions,parms)
    model = svmtrain(labels, instances, strOptions);
    [w,b] = getSvmWeights(model);
    projection = instances * w' + b;
    
    useAUC = take_from_struct(parms,'useAUC',false);
    if useAUC
        accuracy = myauc(labels == 1,projection);
    else
        predictedLabels = sign(projection);
        accuracy = sum(predictedLabels == labels) / length(labels);
    end
end
