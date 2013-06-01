%%
data = loadData('s10a');

%%
figure; plot(firingRates(data.unitSpikeTimes{1}));

%%
ISIs = calcISIs(data.unitSpikeTimes{1});

%%
figure; plot(cellfun(@(x) 1/mean(x), ISIs)); % same as firingRates

figure; plot(cellfun(@(x) 1/median(x), ISIs));
figure; plot(cellfun(@(x) median(x), ISIs));
figure; plot(cellfun(@(x) log(std(x)), ISIs));
figure; plot(cellfun(@(x) std(x)/mean(x), ISIs)); % CV

%%
mUnitPlot(data, @(x) std(x)/mean(x), 'CV(ISI)')

%% 
rasterPlot(data)

%%
figNetworkRates()
figBaseRates()