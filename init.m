
if exist('inited', 'var')
  return
end
setupPath()

parms.dummy=0;

% General parameters
[seed,      parms] = take_from_struct(parms, 'seed', 1);


% parameters for detecting burtsts
[p,         parms] = take_from_struct(parms,'wEdges', 0.65);
[threshold, parms] = take_from_struct(parms, 'threshold', 0.1641);
[T,         parms] = take_from_struct(parms, 'T', 0.5);
[method,    parms] = take_from_struct(parms, 'method', 'lasso');
[estimate_bin_sec, parms] = take_from_struct(parms, 'estimate_bin_sec', 0.05);


inited = true;