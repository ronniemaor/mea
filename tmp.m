function tmp()
    data = struct;
    data.nUnits = 1;
    data.unitSpikeTimes = {[1.11]};
    
    tStart = 1;
    tEnd = 1.5;
    parms = make_parms('estimate_bin_sec', 0.1);
    [scores, scoreTimes] = burstScore(data, tStart, tEnd, parms);
    plot(scoreTimes,scores(:,2),'b-');
    hold on
    plot(1.11,1,'rx')
end
