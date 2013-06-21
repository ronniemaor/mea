function pdf = getDistribution(x,edges)
% Does histogram and returns probabilities for being in each bin
% The bins are defined by the edges (of length N):
% pdf(1) = P(x < edges(1))
% pdf(1 < i <= N) = P(edges(i-1) <= x < edges(i))
% pdf(N+1) = P(x >= edges(N))
%
% Example:
% getDistribution(1:10, [2, 5, 9]) returns [0.1 0.3 0.4 0.2]
%
    n = histc(x, [-Inf sort(edges) Inf]);
    n = n(1:end-1); % remove count of elements that "match Inf"
    pdf = n / sum(n);
end
