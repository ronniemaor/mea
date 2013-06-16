function [do_calc] = cond_calc(filename,do_force,verbose)
%
% do_calc = cond_calc(filename,do_force,verbose)
% Check if a file exists, and print relevant error messages
%


% Handle nargin
  if(nargin<2), do_force=0;end;
  if(nargin<3), verbose=1;end;
  
  p=findstr(filename,'/gal/');
  if(~isempty(p) & p(1)>0)
    filename_prt = filename(p(1):end);
    filename_prt(1) = '~';
  else
    filename_prt = filename;
  end
  filename_prt = shorten_filename(filename);
      
  % Recalculation forced
  if(do_force>0)
    if(verbose>0)
      fprintf('CC: Forced calculation of %s.\n',filename_prt)
    end
    do_calc = 1;
    return;
  end  
  
  % Load from file
  if(exist(filename,'file')>0)
    if(verbose>0),
      fprintf('CC: Load from "%s"\n',filename_prt);
    end;
    do_calc = 0 ; 
  else
    if(verbose>0)
      fprintf('CC: File "%s" not found. Calculate.\n',filename_prt)
    end
    do_calc = 1 ; 
  end
  
return
