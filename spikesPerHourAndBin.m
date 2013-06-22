function [counts, tBin] = spikesPerHourAndBin(data,parms)
% spikesPerHourAndBin(data, params)
% returns spike counts in 3D array: [iUnit, iBinInHour, iHour]
% parms.estimate_bin_sec is the bin size. Default = 1 sec.
% An "hour" is taken as 20 minutes as usual for this data.

    if ~exist('parms','var'); parms = make_parms(); end
    tBin = take_from_struct(parms, 'estimate_bin_sec', 1);
    tHour = 20*60;
    nHours = data.maxUnitFullHours;
    nBins = ceil(nHours*tHour/tBin);
    nBinsPerHour = tHour/tBin; % must be whole number
    
    counts = zeros(data.nUnits, nBins);
    for iUnit=1:data.nUnits
        times = data.unitSpikeTimes{iUnit};
        times = times(times < tBin*nBins);
        bins = ceil( times / tBin );
        unitCounts = sparse(bins, ones(size(bins)), ones(size(bins)));
        counts(iUnit,1:length(unitCounts)) = unitCounts;
    end
    counts = reshape(counts, data.nUnits, nBinsPerHour, nHours);
end
