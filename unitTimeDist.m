function unitTimeDist(ISIs,ymax)
    figure; hold on;
    
    for i=1:length(ISIs)
        times = ISIs{i};
        plot(i*ones(size(times)), times, '.')
    end
    title('ISI distribution over time')
    xlabel('time [hour]')
    ylabel('ISI [sec]')
    if exist('ymax','var')
        ylim([0 ymax])
    end
end