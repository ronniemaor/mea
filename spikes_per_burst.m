function num_spikes = spikes_per_burst(data,beg_times,end_times)
    nBursts = length(beg_times);
    assert(length(end_times) == nBursts);

    spikeTimes = cell2mat(data.unitSpikeTimes');
    
    num_spikes = zeros(1,nBursts);
    for iBurst = 1:nBursts
        tStart = beg_times(iBurst);
        tEnd = end_times(iBurst);
        num_spikes(iBurst) = sum(spikeTimes > tStart & spikeTimes < tEnd);
    end
end
