function [do_calc, varargout] = cond_load(filename, do_force, varargin)
%
% Load results from file if possible & allowed. 
%
% [do_calc, stats] = conditional_load(filename, do_force, varargin)
%
% Example: 
%   vars  = {'x','y'}
%   [do_calc,x,y] = cond_load(filename, do_force, vars{1:end});
%   if(do_calc < 1 ), return; end
%
%

% Debug
%  disp(filename)
%  dbstack
  
  if(do_force>0), 
    do_calc=1;
    n_vars = length(varargin);    
    for i_var = 1: n_vars
      var = varargin{i_var};
      cmd = sprintf('   varargout{%d}=[];',i_var,var);    
      eval(cmd);
    end

    return;
  end;
  
  
% Init var
  vars = varargin;
  n_vars = length(vars);
  for i_var = 1: n_vars 
    cmd = sprintf('%s = [];',vars{i_var}); eval(cmd);
  end
  varargout=[];

  if(nargout-1 ~= length(vars))
    fprintf('Warning: arguments mismatch in cond_load.m\n');
    fprintf('Calling stack is:\n');
    dbstack
    fprintf('End of stack\n');    
    error('arguments mismatch in cond_load.m');
  end
  
  % Check if file exists
  if(exist(filename,'file')>0), 
    do_calc=0;
  else
    do_calc=1;
  end;

  S.dummy=[];
  if(do_calc<1)
      try
	S = load(filename);
      catch
	fprintf('filename = "%s"\n',filename);
	fprintf('Warning: File exist, but could not be read\n');
	do_calc=1;
	keyboard	
      end
  end

  if(exist(filename,'file')==0)
    filename_prt = shorten_filename(filename);
    fprintf('File "%s" dosent exist.\n',filename_prt);
    fprintf('> Calculate all vars %s\n',datestr(now,13));
    for i_var = 1: n_vars
      var = vars{i_var};
      cmd = sprintf('   varargout{%d}=[];',i_var,var);    
      eval(cmd);
    end
    return
  end


  % File exists, Check if var was read
  for i_var = 1: n_vars
    var = vars{i_var};
    if(isfield(S,var)==0)
      do_calc=1;      
      fprintf('No variable "%s" found. Recalculate\n', var);
      cmd = sprintf('   varargout{%d}=[];',i_var);    
    else
      cmd = sprintf('   varargout{%d}=S.%s;',i_var,var);
    end 
    
    eval(cmd);
  end
  
  
%  % Check if var was read
%  for(i_var = 1: n_vars)
%    var = vars{i_var};
%    cmd1 = sprintf('if(isfield(S,''%s'')==0), do_calc=1;',var);
%    if(do_force<1)
%      cmd2 = sprintf('   fprintf(''No variable "%s" found. Recalc\\n'');', var);
%    else
%      cmd2 = sprintf('   fprintf(''Force calculation of "%s"\\n'');', var);
%    end
%    cmd3 = sprintf('   varargout{%d}=[];',i_var);
%    cmd4 = sprintf('else', var);
%    cmd5 = sprintf('   varargout{%d}=S.%s;',i_var,var);
%    cmd6 = sprintf('end');
    
%    % [cmd1 cmd2  cmd3  cmd4  cmd5  cmd6]
%    eval([cmd1 cmd2 cmd3 cmd4 cmd5 cmd6]);
%  end
  
return
end