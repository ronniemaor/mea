function x = msum(x,dims)
% sum along multiple dimensions
    for d = dims
        x = sum(x,d);
    end
end