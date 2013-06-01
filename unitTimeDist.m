function unitTimeDist(ISIs)
    figure; hold on;
    
    for i=1:length(ISIs)
        times = ISIs{i};
        plot(i*ones(size(times)), times, '.')
    end
end