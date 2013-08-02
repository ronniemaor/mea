function bins = divideToBins(points,nBins)
    bins = cell(nBins,1);
    n = length(points);
    binSize = floor(n/nBins);
    remainder = mod(n,nBins);
    nTaken = 0;
    for i = 1:nBins
        k = binSize;
        if remainder > 0
            k = k + 1;
            remainder = remainder - 1;
        end
        from = nTaken+1;
        to = from + k - 1;
        bins{i} = points(from:to);
        nTaken = nTaken + k;
    end
end