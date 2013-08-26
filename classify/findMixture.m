function findMixture(parms)
    data = loadData('bac10a',1);
    suffixes = {'baseline-yuval', 'early', 'recovery-yuval'};
    lstP = 0:0.05:1;
    parms.useAUC = take_from_struct(parms,'useAUC',false);
    
    nSuffixes = length(suffixes);
    figure;    
    for iSuffix = 1:nSuffixes
        suffix = suffixes{iSuffix};
        accuracies = getAccuracies(data,suffix,lstP,parms);
        plot(lstP,accuracies);
        title(sprintf('%s - dependence on w_{edges}',data.sessionKey))
        xlabel('w_{edges}')
        if parms.useAUC
            ylabel('AUC')
        else
            ylabel('% correct')
        end
        legend(suffixes(1:iSuffix),'Location','NorthEastOutside');
        drawnow
        hold all;
    end
end

function accuracies = getAccuracies(data,suffix,lstP,parms)
    % load the labels
    fname = getLabelsFilename(data.sessionKey, suffix);
    labels = load(fname);

    nYes = length(labels.yesTimes);
    nNo = length(labels.noTimes);
    n = nYes + nNo;
    T = labels.T;
    
    % convert the data to libsvm input format
    nBinsPerWindow = size(burstFeatures(data, 100, 100+T, parms),1);
    edges = zeros(nBinsPerWindow, n);
    activities = zeros(nBinsPerWindow, n);
    svmLabels = zeros(n,1);
    for i=1:n
        if i <= nYes
            lbl = 1;
            t = labels.yesTimes(i);
        else
            lbl = -1;
            t = labels.noTimes(i-nYes);
        end
        svmLabels(i) = lbl;
        features = burstFeatures(data, t, t+T, parms);
        activities(:,i) = features(:,1);        
        edges(:,i) = max(features(:,2), features(:,3));
    end
    
    lstC = take_from_struct(parms,'lstC',1000);
    nTrials = take_from_struct(parms,'nTrials',50);
    accuracies = zeros(1,length(lstP));
    for iP = 1:length(lstP)
        p = lstP(iP);
        
        binScores = p*edges + (1-p)*activities;
        scores = max(binScores,[],1); 
        svmInstances = scores';
        
        trialAccuracies = zeros(nTrials,length(lstC));
        for iTrial=1:nTrials
            trialAccuracies(iTrial,:) = arrayfun(@(C) tryHyper(svmLabels,svmInstances,C,parms), lstC);
        end
        accuracies(iP) = max(mean(trialAccuracies,1)); % mean over trials, then take best C
    end
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
        idxFold = [bigFolds{iFold}; smallFolds{iFold}];
        accuracies(iFold) = trainOne(svmLabels, svmInstances, idxFold, strOptions, parms);
    end
    cvAccuracy = mean(accuracies);

    [overfitAccuracy, model] = trainOne(svmLabels, svmInstances, [], strOptions, parms);
end

function [accuracy,model] = trainOne(labels,instances,idxTest,strOptions,parms)
    if isempty(idxTest)
        testLabels = labels;
        testInstances = instances;
        trainLabels = labels;
        trainInstances = instances;
    else        
        posTest = zeros(1,length(labels));
        posTest(idxTest) = 1;
        posTest = logical(posTest);
        posTrain = ~posTest;
        testLabels = labels(posTest);
        testInstances = instances(posTest,:);
        trainLabels = labels(posTrain);
        trainInstances = instances(posTrain,:);
    end
    
    % training
    model = svmtrain(trainLabels, trainInstances, strOptions);
    
    % testing
    [w,b] = getSvmWeights(model);
    testProjection = testInstances * w' + b;
    if parms.useAUC
        accuracy = myauc(testLabels == 1,testProjection);
    else
        predictedLabels = sign(testProjection);
        accuracy = sum(predictedLabels == testLabels) / length(testLabels);
    end
end
