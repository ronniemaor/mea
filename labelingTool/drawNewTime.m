function drawNewTime(handles)
    parms = handles.parms;
    
    tStart = chooseTime(parms);
    tEnd = tStart + parms.T;
    dt = parms.contextSize * parms.T;
    tContextStart = tStart - dt;
    tContextEnd = tEnd + dt;

    axes(handles.axesRaster);
    cla;
    for iUnit = 1:parms.data.nUnits
        times = parms.data.unitSpikeTimes{iUnit};
        times = times(times > tContextStart & times <= tContextEnd);
        plot(times, iUnit*ones(size(times)), 'b.')
        hold on;
        times = times(times > tStart & times <= tEnd);
        plot(times, iUnit*ones(size(times)), 'r.')
        xlim([tContextStart tContextEnd])
        ylim([0 parms.data.nUnits+1])
    end
    set(handles.axesRaster, 'FontSize', 16)
    xlabel('t [sec]')
    ylabel('unit number')
    
    numDone = length(handles.state.yesTimes) + length(handles.state.noTimes);
    set(handles.textSampleNumber, 'String', num2str(numDone))
    
    handles.state.tStart = tStart;
    guidata(handles.figureLabeling, handles);
end

function t = chooseTime(parms)
    tHour = 20*60;
    iHour = parms.fromHour + floor(rand*parms.nHours);
    nBins = floor(tHour/parms.T);
    nBuffer = ceil(parms.contextSize);
    nLegalBins = nBins - 2*nBuffer;
    dt = parms.T * (nBuffer + floor(rand*nLegalBins));
    t = (iHour-1)*tHour + dt;
end