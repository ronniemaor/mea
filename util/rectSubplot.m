function [nRows, nCols] = rectSubplot(nPlots)
    nRows = ceil(sqrt(nPlots));
    nCols = ceil(nPlots/nRows);
end