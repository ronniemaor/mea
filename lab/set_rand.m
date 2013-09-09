function old_seed = set_rand(seed)
% set_rand(seed)
  old_seed = rand('seed'); %#ok
  rand('seed', seed); %#ok  
end