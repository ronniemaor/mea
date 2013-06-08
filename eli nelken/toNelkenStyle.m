function uM = toNelkenStyle(data)
    uM = cell(3,100);
    windowStartPos = [0, 4800, 36000]; % hour 1, 5, 34
    windowSize = 1200; % 20 minutes
    for i=1:data.nChannels
        chNum = data.channelNumbers(i);
        ch = data.channels{i};
        times = ch(:,3);
        for iper=1:3
            tStart = windowStartPos(iper);
            tEnd = tStart + windowSize;
            idx = times >= tStart & times < tEnd;
            filteredCh = ch(idx,:);
            filteredCh(:,3) = filteredCh(:,3) - tStart;
            uM{iper,chNum} = filteredCh;
        end        
    end
end