%
% init - project specific initialization
%

  if exist('inited','var')>0
    fprintf('Already inited, skip.\n');
    return
  end
  fprintf('Start initialization: begin init.m\n');
  % General control variables
  parms.dummy=0;
  [do_force, parms] = take_from_struct(parms, 'do_force',     0);
  [do_plot,  parms] = take_from_struct(parms, 'do_plot',      0);
  [do_save,  parms] = take_from_struct(parms, 'do_save',      0);

  fprintf('Finished initialization: out of init.m\n');
  inited = 1;
