function t = chooseTime(handles)
    chooser = getappdata(handles.figureLabeling, 'chooser');
    if isempty(chooser)
        chooser = constructChooser(handles.parms);
        setappdata(handles.figureLabeling, 'chooser', chooser);
    end
    t = chooser.drawItem();
end

function chooser = constructChooser(parms)
    %fprintf('Constructing chooser\n')
    data = parms.data;
    tHour = 20*60;
    nBins = floor(tHour/parms.T);
    nBuffer = ceil(parms.contextSize);
    nLegalBins = nBins - 2*nBuffer;
    bufferTime = nBuffer * parms.T;
    dt = parms.T * (0:nLegalBins-1);
    
    tMiniBin = 0.05;
    nMiniPerBin = round(parms.T / tMiniBin);
    tMiniBin = parms.T / nMiniPerBin; % make it a whole multiple

    nMiniBins = nLegalBins * nMiniPerBin;
    candidates = [];
    probs = [];
    for iHour = parms.fromHour:(parms.fromHour + parms.nHours - 1);
        tStart = (iHour-1)*tHour + bufferTime;
        tEnd = iHour*tHour - bufferTime;        

        hourCandidates = tStart + dt;
        candidates = [candidates hourCandidates];

        unitActiveMiniBins = zeros(data.nUnits,nMiniBins);
        for iUnit = 1:data.nUnits
            times = data.unitSpikeTimes{iUnit};
            times = times(times > tStart & times <= tEnd) - tStart;
            miniBins = unique(ceil(times/tMiniBin));
            miniBins = miniBins(miniBins <= nMiniBins);
            unitActiveMiniBins(iUnit,miniBins) = 1;
        end
        
        pActivePerMiniBin = sum(unitActiveMiniBins) / data.nUnits;
        maxActivePerBin = max(reshape(pActivePerMiniBin, nMiniPerBin, nLegalBins));
        hourProbs = maxActivePerBin;
        probs = [probs hourProbs];
    end
    fBias = @(p) p^2;
    nBuckets = 25;
    chooser = BiasedChooser(candidates, probs, make_parms('fBias', fBias, 'nBuckets', nBuckets));
end
