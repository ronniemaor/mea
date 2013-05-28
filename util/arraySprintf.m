function s = arraySprintf(fmt,vals)
s = cell(1,length(vals));
for i = 1:length(vals)
    v = vals(i);
    s{i} = sprintf(fmt, v);
end