function drawNewTime(handles)
    parms = handles.parms;
    
    tStart = chooseTime(handles);
    tEnd = tStart + parms.T;
    dt = parms.contextSize * parms.T;
    tContextStart = tStart - dt;
    tContextEnd = tEnd + dt;
    
    tX = take_from_struct(parms,'tX',10);
    if tContextEnd - tContextStart > tX
        xmin = tContextStart;
        xmax = tContextEnd;
    else
        xMid = (tContextStart + tContextEnd)/2;
        xmin = xMid - tX/2;
        xmax = xMid + tX/2;
    end    

    axes(handles.axesRaster);
    cla;
    for iUnit = 1:parms.data.nUnits
        times = parms.data.unitSpikeTimes{iUnit};
        times = times(times > tContextStart & times <= tContextEnd);
        plot(times, iUnit*ones(size(times)), '.', 'color', 0.8*[1 1 1])
        hold on;
        times = times(times > tStart & times <= tEnd);
        plot(times, iUnit*ones(size(times)), '.', 'color', [1 0 0.2])
        xlim([xmin xmax])
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

