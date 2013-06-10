%%
figNetworkRates()
figBaseRates()

%%
data = loadData('s10a');

%% 
rasterPlot(data)

%%
firstHours(loadData('s10a'));

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
