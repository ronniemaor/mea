function isiDkl(data,iUnit)
    ISIs = calcISIs(data.unitSpikeTimes{iUnit});
    baseISIs = [];
    for i = 1:4
        baseISIs = [baseISIs; ISIs{i}];
    end
    
    N = 10;
    edges = zeros(1,N-1);
    for i=1:N-1
        edges(i) = prctile(baseISIs, i*100/N);
    end  
    
    statsDkl = cellfun(@(x) calcDkl(x,edges,N), ISIs);
    statsRate = cellfun(@(x) 1/mean(x), ISIs);
    
    subplot(2,1,1)
    plot(statsDkl)
    title(sprintf('D_{KL} of ISI(t) relative to baseline hours - %s, unit %d',data.sessionKey,iUnit))
    xlabel('Hour number')
    set(gca,'XTick',1:length(statsDkl))
    ylabel('D_{KL}')
    
    subplot(2,1,2)
    plot(statsRate)
    title(sprintf('Mean firing rate - %s, unit %d',data.sessionKey,iUnit))
    xlabel('Hour number')
    set(gca,'XTick',1:length(statsDkl))
    ylabel('rate [Hz]')
end

function Dkl = calcDkl(ISIs,edges,N)
    pdf = getDistribution(ISIs,edges);
    pdf = pdf(pdf > eps);
    H = -sum(pdf .* log2(pdf));
    Dkl = log2(N) - H;
end

