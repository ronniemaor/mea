%%
data = loadData('s10a');

%%
figure; plot(firingRates(data.unitSpikeTimes{1}));

%%
ISIs = calcISIs(data.unitSpikeTimes{1});

%%
fRate = @(x) 1/mean(x);
fMedRate = @(x) 1/median(x);
fMed = @(x) 1000*median(x); % in msec
fCV = @(x) std(x)/mean(x);

%%

unitISIstat(ISIs, fRate, 'f [Hz]', 'Mean Firing Rate')
unitISIstat(ISIs, fMedRate, '1/median(ISI) [Hz]', 'Median Firing Rate')
unitISIstat(ISIs, fMed, 'median(ISI) [msec]', 'Median ISI')
unitISIstat(ISIs, fCV, 'CV', 'CV of ISI')

%%
mUnitPlot(data, @(x) std(x)/mean(x), 'CV time course for all units')

%%
unitTimeDist(calcISIs(data.unitSpikeTimes{1}))

%% 
rasterPlot(data)

%%
figNetworkRates()
figBaseRates()