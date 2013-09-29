%%
figNetworkRates()
figBaseRates()

%%
data = loadData('bac10a');

%% 
rasterPlot(data)

%%
rasterWithBursts(data,make_parms('burst_mode', 'gamma_per_bin', 'significance_threshold', 0.1, 'estimate_bin_sec', 1));
rasterWithBursts(data,make_parms('burst_mode', 'fraction_active', 'fraction', 0.5, 'estimate_bin_sec', 0.5));

%% std(fraction of units active) over time
numActivePlots(loadData('bac1c'))
numActiveStd(make_parms('filter', 'bac1', 'normalize', 1))
numActiveStdMultipleBinSizes(make_parms('filter', 'bac1', 'bin_sizes', [0.1 1 10]))
numActiveDist(loadData('bac1c'), make_parms('frames', [2 4 20 35 45], 'hist_bin', 0.04, 'estimate_bin_sec', 1))

%% std(rates)
rateStd(make_parms('estimate_bin_sec', 1, 'filter', 'bac1'))

%%
firstHours(loadData('bac10a'));

%%
figure; plot(firingRates(data.unitSpikeTimes{1}));

%% whole network firing rate per hour
figure; plot(firingRates(cell2mat(data.unitSpikeTimes')));

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
mUnitPlot(data, fRate, 'Firing rate time course for all units')
mUnitPlot(data, fMedRate, 'Median Firing rate time course for all units')
mUnitPlot(data, fMed, 'Median ISI time course for all units')
mUnitPlot(data, fCV, 'CV time course for all units')

%%
unitTimeDist(calcISIs(data.unitSpikeTimes{1}))

%% 
isiDkl(data,1)

for iUnit=1:data.nUnits
    isiDkl(data,iUnit)
    pause
end

%% Working with Eli Nelken's code
uM = toNelkenStyle(loadData('bac10a'));

%% burst classification
labeling(make_parms('T',0.5, 'contextSize',8, 'data',data, 'fromHour',3, 'nHours', 1, 'fileSuffix', 'baseline'))
browseLabels(make_parms('data',data,'fileSuffix','merged-yuval', 'estimate_bin_sec', 0.05, 'wEdges', 0.65, 'threshold', 0.1641))
merged = mergeLabels('bac10a', {'baseline-yuval', 'early', 'recovery-yuval'}, 'merged-yuval');
findC(make_parms('data',data,'fileSuffix','baseline', 'estimate_bin_sec', 0.05))
findMixture(make_parms('data',data, 'suffixes', {'baseline-yuval', 'early'}, 'useAUC', 1));
[model,accuracy] = train(make_parms('data',data,'fileSuffix','merged-yuval', 'estimate_bin_sec', 0.05, 'C', 1000));
[w,b] = getSvmWeights(model); % threshold = -b/w
showROC(make_parms('data',data,'suffixes',{'merged'},'wEdges',0.65,'threshold',0.1641));
checkAccuracy(make_parms('data',data,'fileSuffix','merged','threshold',0.1641,'wEdges',0.65))

hourlyBurstRate(data, make_parms('wEdges',0.1, 'threshold', 0.1125))
trainBurstEdges()
hourlyBurstStats(data,parms)
