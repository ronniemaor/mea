function figNetworkRates()
    figure
    keys = allSessionKeys();
    for i=1:length(keys)
        subplot(2,2,i)
        networkRates(loadData(keys{i},1));    
    end
    topLevelTitle('Whole network firing rates')
end