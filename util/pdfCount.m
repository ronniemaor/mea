function [p,x] = pdfCount(Y,nbins)
    [f,x]=hist(Y,nbins);
    p = f/trapz(x,f);
end