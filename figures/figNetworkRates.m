function figNetworkRates()
    figure
    keys = allSessionKeys();
    nSessions = length(keys);
    nRows = ceil(sqrt(nSessions));
    nCols = ceil(nSessions/nRows);
    for i=1:nSessions
        subplot(nRows,nCols,i)
        networkRates(loadData(keys{i},1));
    end
    topLevelTitle('Whole network firing rates')
end