figure
keys = allSessionKeys();
for i=1:length(keys)
    subplot(2,2,i)
    baseRates(loadData(keys{i},1));    
end % test2
