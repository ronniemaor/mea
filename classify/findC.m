function findC(parms)
    parms.useAUC = take_from_struct(parms,'useAUC',false);
    parms.wEdges = take_from_struct(parms,'wEdges',0.65);
    p = parms.wEdges;

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
        scores = p*edges + (1-p)*features(:,1);
        fi = max(scores,[],1); 
        
        svmInstances = [svmInstances; fi];
        svmLabels = [svmLabels; lbl];
    end
    
    lstC = take_from_struct(parms,'lstC',logspace(-3,3,10));

    nTrials = take_from_struct(parms,'nTrials',50);
    trialCvAccuracies = zeros(nTrials,length(lstC));
    trialOverfitAccuracies = zeros(nTrials,length(lstC));
    for iTrial=1:nTrials
        [trialCvAccuracies(iTrial,:), ~, trialOverfitAccuracies(iTrial,:)] = arrayfun(@(C) tryHyper(svmLabels,svmInstances,C,parms), lstC);
    end
    cvAccuracy = mean(trialCvAccuracies,1);
    overfitAccuracy = mean(trialOverfitAccuracies,1);
    
    figure;
    plot(log10(lstC),100*cvAccuracy,'b-',log10(lstC),100*overfitAccuracy,'r-');
    title(sprintf('%s %s - dependaece on C',parms.data.sessionKey,parms.fileSuffix));
    xlabel('log_{10}(C)')
    if parms.useAUC
        ylabel('AUC')
    else
        ylabel('accuracy (%correct)')
    end
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
