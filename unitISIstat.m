function unitISIstat(ISIs, f, ylbl, ttl)
    stats = cellfun(f,ISIs);
    figure;
    plot(stats);
    xlabel('time [hour]')
    if exist('ylbl','var')
        ylabel(ylbl)
    end
    if exist('ttl','var')
        title(ttl)
    end
end