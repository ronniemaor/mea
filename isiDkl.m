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
    
    fDkl = @(x) calcDkl(x,edges,N);
    stats = cellfun(fDkl, ISIs);
    plot(stats)
    title(sprintf('D_{KL} of ISI(t) relative to baseline hours - %s, unit %d',data.sessionKey,iUnit))
    xlabel('Hour number')
    set(gca,'XTick',1:length(stats))
    ylabel('D_{KL}')
end

function Dkl = calcDkl(ISIs,edges,N)
    pdf = getDistribution(ISIs,edges);
    pdf = pdf(pdf > eps);
    H = -sum(pdf .* log2(pdf));
    Dkl = log2(N) - H;
end

function pdf = getDistribution(ISIs,edges)
    n = histc(ISIs, [-Inf edges Inf]);
    n = n(1:end-1); % remove count of elements that "match Inf"
    pdf = n / sum(n);
end

