%%
figNetworkRates()
figBaseRates()

%%
data = loadData('s10a');

%% 
rasterPlot(data)

%%
rasterWithBursts(data,make_parms('burst_mode', 'gamma_per_bin', 'significance_threshold', 0.1, 'estimate_bin_sec', 1));
rasterWithBursts(data,make_parms('burst_mode', 'fraction_active', 'fraction', 0.5, 'estimate_bin_sec', 0.5));

%% std(fraction of units active) over time
numActivePlots(loadData('s1c'))
numActiveStd(make_parms('filter', 's1', 'normalize', 1))
numActiveStdMultipleBinSizes(make_parms('filter', 's1', 'bin_sizes', [0.1 1 10]))
numActiveDist(loadData('s1c'), make_parms('frames', [2 4 10 20 25 30 35 40 45])) % also: estimate_bin_sec, hist_bin

%% std(rates)
rateStd(make_parms('estimate_bin_sec', 1, 'filter', 's1'))

%%
firstHours(loadData('s10a'));

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
uM = toNelkenStyle(loadData('s10a'));
